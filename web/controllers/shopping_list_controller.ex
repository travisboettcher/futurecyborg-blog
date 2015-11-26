defmodule FutureCyborg.ShoppingListController do
  use FutureCyborg.Web, :controller

  alias FutureCyborg.ShoppingList
  alias FutureCyborg.ListItem

  plug :scrub_params, "shopping_list" when action in [:create, :update]

  def index(conn, _params) do
    shopping_lists = Repo.all(ShoppingList)
    render(conn, "index.html", shopping_lists: shopping_lists)
  end

  def new(conn, _params) do
    changeset = ShoppingList.changeset(%ShoppingList{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"shopping_list" => shopping_list_params}) do
    changeset = ShoppingList.changeset(%ShoppingList{}, shopping_list_params)

    case Repo.insert(changeset) do
      {:ok, _shopping_list} ->
        conn
        |> put_flash(:info, "Shopping list created successfully.")
        |> redirect(to: shopping_list_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    shopping_list = Repo.get!(ShoppingList, id)
      |> Repo.preload([:list_items])
    render(conn, "show.html", shopping_list: shopping_list) 
  end

  def edit(conn, %{"id" => id}) do
    shopping_list = Repo.get!(ShoppingList, id)
    changeset = ShoppingList.changeset(shopping_list)
    render(conn, "edit.html", shopping_list: shopping_list, changeset: changeset)
  end

  def update(conn, %{"id" => id, "shopping_list" => shopping_list_params}) do
    shopping_list = Repo.get!(ShoppingList, id)
    changeset = ShoppingList.changeset(shopping_list, shopping_list_params)

    case Repo.update(changeset) do
      {:ok, shopping_list} ->
        conn
        |> put_flash(:info, "Shopping list updated successfully.")
        |> redirect(to: shopping_list_path(conn, :show, shopping_list))
      {:error, changeset} ->
        render(conn, "edit.html", shopping_list: shopping_list, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    shopping_list = Repo.get!(ShoppingList, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(shopping_list)

    conn
    |> put_flash(:info, "Shopping list deleted successfully.")
    |> redirect(to: shopping_list_path(conn, :index))
  end
end
