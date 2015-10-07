defmodule HelloPhoenix.PageController do
  use HelloPhoenix.Web, :controller
  alias HelloPhoenix.Post

  def index(conn, _params) do
    posts = Repo.all from p in Post, 
      order_by: [desc: p.updated_at],
      select: p
    render conn, "index.html", posts: posts
  end
end
