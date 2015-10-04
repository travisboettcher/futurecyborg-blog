defmodule HelloPhoenix.MarkdownParser do
  alias HelloPhoenix.Post
  alias Earmark

  def parse_markdown(%Post{content: content} = md_post) do
    html_post_content = Earmark.to_html(content)
    %{md_post | content: html_post_content}
  end
end
