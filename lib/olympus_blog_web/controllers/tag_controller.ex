defmodule OlympusBlogWeb.TagController do
  use OlympusBlogWeb, :controller

  alias OlympusBlog.Articles

  action_fallback OlympusBlogWeb.FallbackController

  def index(conn, _params) do
    conn
    |> render("index.json", tags: Articles.list_tags())
  end
end
