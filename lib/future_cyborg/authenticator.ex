defmodule FutureCyborg.Authenticator do
  alias FutureCyborg.User
  alias FutureCyborg.Repo
  import Comeonin.Bcrypt, only: [checkpw: 2]
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import Plug.Conn
  
  def init(_options), do: nil

  def call(conn, _) do
    case authenticate(conn) do
      {:ok, conn} -> conn
      {:error, msg} -> 
        conn 
        |> put_flash(:error, msg)
        |> redirect(to: FutureCyborg.Router.Helpers.login_path(conn, :index))
        |> halt
    end
  end

  def check_password(conn, username, password) do 
    user = get_user(username)
    if not is_nil(user) and checkpw(password, user.password) do
      conn = conn |> fetch_session |> put_session(:user, user)
      {:ok, conn}
    else
      {:error, "Invalid username or password."}
    end
  end

  def get_user(username) do
    Repo.get_by(User, username: username)
  end

  def authenticate(conn) do
    conn = fetch_session(conn)

    if not is_nil(get_session(conn, :user)) do
      conn = assign(conn, :current_user, get_session(conn, :user))
      {:ok, conn}
    else
      {:error, "Not logged in."}
    end
  end

  def logged_in?(conn) do
    user = conn |> fetch_session |> get_session(:user)
    not is_nil(user)
  end
end
