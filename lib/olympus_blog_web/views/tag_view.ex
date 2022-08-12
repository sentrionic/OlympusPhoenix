defmodule OlympusBlogWeb.TagView do
  use OlympusBlogWeb, :view
  alias OlympusBlogWeb.TagView

  def render("index.json", %{tags: tags}) do
    render_many(tags, TagView, "tag.json")
  end

  def render("tag.json", %{tag: tag}) do
    tag.name
  end
end
