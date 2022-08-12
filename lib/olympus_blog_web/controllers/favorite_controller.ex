defmodule OlympusBlogWeb.FavoriteController do
  use OlympusBlogWeb, :controller

  alias OlympusBlog.Account
  alias OlympusBlog.Articles
  alias OlympusBlog.Articles.Favorite
  alias OlympusBlog.Articles.Article

  action_fallback OlympusBlogWeb.FallbackController

  def create(conn, %{"slug" => slug}) do
    IO.puts(slug)

    with user <- Account.get_user!(get_session(conn, :user_id)),
         %Article{} = article <- Articles.get_article_by_slug(slug),
         {:ok, %Favorite{}} <- Articles.create_favorite(user, article) do
      article =
        Articles.get_article_by_slug(slug, user)
        |> Articles.article_preload()

      conn
      |> put_status(:created)
      |> render("show.json", article: article)
    end
  end

  def delete(conn, %{"slug" => slug}) do
    with user <- Account.get_user!(get_session(conn, :user_id)),
         %Article{} = article <-
           Articles.get_article_by_slug(slug, user)
           |> Articles.article_preload(),
         {1, _} <- Articles.delete_favorite(user, article) do
      conn
      |> render("show.json",
        article:
          article
          |> Map.update!(:favorited, fn _ -> false end)
      )
    end
  end
end
