defmodule OlympusBlogWeb.ArticleController do
  use OlympusBlogWeb, :controller

  alias OlympusBlog.Account
  alias OlympusBlog.Articles
  alias OlympusBlog.Articles.Article

  action_fallback OlympusBlogWeb.FallbackController

  def index(conn, params) do
    keywords = for {key, val} <- params, do: {String.to_atom(key), val}

    keywords =
      case Account.get_user(get_session(conn, :user_id)) do
        nil -> keywords
        user -> keywords |> Keyword.put(:user, user)
      end

    articles =
      Articles.list_articles(keywords)
      |> Articles.article_preload()

    render(conn, "index.json", articles: articles, hasMore: false)
  end

  def create(conn, params) do
    with user <- Account.get_user(get_session(conn, :user_id)),
         params <- Map.put(params, "author_id", user.id),
         {:ok, %Article{} = article} <- Articles.create_article(params) do
      article =
        article
        |> Articles.article_preload()

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.article_path(conn, :show, article))
      |> render("show.json", article: article)
    end
  end

  def show(conn, %{"slug" => slug}) do
    user = Account.get_user(get_session(conn, :user_id))

    with %Article{} = article <-
           Articles.get_article_by_slug(slug, user),
         article <- article |> Articles.article_preload() do
      render(conn, "show.json", article: article)
    end
  end

  def update(conn, %{"slug" => slug} = params) do
    with article <- Articles.get_article_by_slug(slug),
         {:ok, %Article{} = article} <- Articles.update_article(article, params) do
      article =
        article
        |> Articles.article_preload()

      render(conn, "show.json", article: article)
    end
  end

  def delete(conn, %{"slug" => slug}) do
    with article <- Articles.get_article_by_slug(slug),
         {:ok, %Article{}} <- Articles.delete_article(article) do
      render(conn, "show.json", article: article)
    end
  end

  # TODO: Get hasMore
  def feed(conn, params) do
    keywords = for {key, val} <- params, do: {String.to_atom(key), val}

    user = Account.get_user(get_session(conn, :user_id))

    articles =
      Articles.list_articles_feed(user, keywords)
      |> Articles.article_preload()

    render(conn, "index.json", articles: articles, hasMore: false)
  end
end
