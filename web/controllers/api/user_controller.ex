defmodule HelloPhoenix.API.UserController do
  use HelloPhoenix.Web, :controller
  alias HelloPhoenix.User

  def index(conn, %{"username" => username}) do
    users = Repo.all(from u in User,
       where: u.username == ^username)
       |> Enum.map(&(Map.take(&1, [:username])))
    json conn, %{users: users}
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(User, id) do
      nil  ->
        conn |> send_resp(404, "")
      user ->
        user = Map.take(user, [:id, :username])
        json conn, %{user: user}
    end
  end
end
