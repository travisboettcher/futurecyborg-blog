defmodule HelloPhoenix.PageController do
  use HelloPhoenix.Web, :controller

  def index(conn, _params) do
    posts = Repo.all from p in HelloPhoenix.Post, 
      order_by: [desc: p.updated_at],
      select: p
    render conn, "index.html", posts: posts
  end
end
