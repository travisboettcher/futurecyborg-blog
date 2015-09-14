defmodule HelloPhoenix.LoginController do
  use HelloPhoenix.Web, :controller
  alias HelloPhoenix.User
  import HelloPhoenix.Authenticator, only: [check_password: 3]

  def index(conn, _params) do
    render conn, "index.html"
  end

  def login(conn, %{"username" => username, "password" => password}) do
    case check_password(conn, username, password) do
      {:ok, conn} ->
        redirect(conn, to: user_path(conn, :index))
      {:error, msg} ->
        conn
        |> put_flash(:error, msg)
        |> redirect(to: login_path(conn, :index))
    end
  end

  def logout(conn, _params) do
    conn
    |> fetch_session
    |> delete_session(:user)
    |> redirect(to: "/")
  end

  def signup(conn, user_params) do
    # Scrub the params so creation will fail for empty username or password
    scrubbed_params = scrub_params(user_params)
    changeset = User.changeset(%User{}, scrubbed_params)

    case Repo.insert(changeset) do
      {:ok, _user} ->
        login(conn, scrubbed_params)
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "User creation failed.")
        |> redirect(to: login_path(conn, :index))
    end
  end

  def scrub_params(params) do
    for {k, v} <- params,
      v != nil,
      v_stripped = String.strip(v),
      String.length(v_stripped) > 0,
      into: %{},
      do: {k, v_stripped}
  end
end
