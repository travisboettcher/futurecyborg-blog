defmodule HelloPhoenix.PostController do
  use HelloPhoenix.Web, :controller
  import Plug.Conn
  import Phoenix.HTML, only: [safe_to_string: 1, html_escape: 1]

  alias HelloPhoenix.Post
  alias HelloPhoenix.Authorizer
  alias HelloPhoenix.MarkdownParser

  plug :scrub_params, "post" when action in [:create, :update]
  plug :find_post, %{id: "id"} when action in [:show, :edit, :update, :delete]
  plug :increment_views when action in [:show]
  plug :authorize_post when action in [:edit, :update, :delete]
  plug :escape_html, "post" when action in [:create, :update]
  plug :parse_markdown when action in [:show]

  def index(conn, _params) do
    user = conn |> fetch_session |> get_session(:user)
    posts = Repo.all from p in Post,
      where: p.user_id == ^user.id,
      select: p
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    user = conn |> fetch_session |> get_session(:user)
    post_params = post_params
      |> Dict.put_new("user_id", user.id)
      |> Dict.put_new("likes", 0)
      |> Dict.put_new("views", 0)
    
    changeset = Post.changeset(%Post{}, post_params)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: post_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _) do
    post = conn.assigns[:post] |> Repo.preload [:user]
    render(conn, "show.html", post: post)
  end

  def edit(conn, _) do
    post = conn.assigns[:post]
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"post" => post_params}) do
    post = conn.assigns[:post]
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, _) do
    post = conn.assigns[:post]

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end
  
  defp find_post(%Plug.Conn{params: %{"id" => id}} = conn, _) do
    case Repo.get(Post, id) do
      nil ->
        conn |> put_flash(:info, "That post wasn't found") |> redirect(to: "/") |> halt
      post ->
        assign(conn, :post, post)
    end
  end

  defp authorize_post(conn, _) do
    user = conn |> fetch_session |> get_session(:user)
    if Authorizer.can_access?(user, conn.assigns[:post]) do
      conn
    else
      conn |> put_flash(:info, "You can't access that page") |> redirect(to: "/") |> halt
    end
  end

  defp parse_markdown(conn, _) do
    md_post = conn.assigns[:post]
    html_post = MarkdownParser.parse_markdown(md_post)
    assign(conn, :post, html_post)
  end

  defp escape_html(%Plug.Conn{params: %{"post" => post_params}} = conn, _) do
    safe_content = html_escape(post_params["content"])
    content_string = safe_to_string(safe_content)
    safe_post_params = %{post_params | "content" => content_string}
    escaped_params = %{conn.params | "post" => safe_post_params}
    escaped_conn = %{conn | params: escaped_params}
    escaped_conn
  end

  defp increment_views(conn, _) do
    post = conn.assigns[:post]
    updated_post = Post.changeset(post, %{views: post.views + 1})
      |> Repo.update!
    assign(conn, :post, updated_post)
  end
end
