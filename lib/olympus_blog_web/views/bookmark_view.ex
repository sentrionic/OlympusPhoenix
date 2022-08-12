defmodule OlympusBlogWeb.BookmarkView do
  use OlympusBlogWeb, :view

  alias OlympusBlogWeb.ArticleView

  def render("show.json", params) do
    ArticleView.render("show.json", params)
  end
end
