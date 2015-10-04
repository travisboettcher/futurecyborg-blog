defmodule HelloPhoenix.PageController do
  use HelloPhoenix.Web, :controller
  alias HelloPhoenix.Post
  alias HelloPhoenix.MarkdownParser

  def index(conn, _params) do
    posts = Repo.all from p in Post, 
      order_by: [desc: p.updated_at],
      select: p
    posts_parsed = Enum.map(posts, &(MarkdownParser.parse_markdown &1))
    render conn, "index.html", posts: posts_parsed
  end
end
