defmodule HelloPhoenix.MarkdownParser do
  def parse_markdown(content) do
    content |> Earmark.to_html |> Phoenix.HTML.raw
  end
end
