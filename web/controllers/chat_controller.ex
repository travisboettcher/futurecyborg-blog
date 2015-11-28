defmodule FutureCyborg.ChatController do
  use FutureCyborg.Web, :controller

  def index(conn, _params) do
    conn = fetch_session(conn)
    conn = assign(conn, :current_user, get_session(conn, :user))
    render conn, "index.html"
  end
end
