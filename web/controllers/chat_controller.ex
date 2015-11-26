defmodule FutureCyborg.ChatController do
  use FutureCyborg.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
