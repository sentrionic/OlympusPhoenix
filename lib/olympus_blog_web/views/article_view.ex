defmodule OlympusBlogWeb.ArticleView do
  use OlympusBlogWeb, :view
  alias OlympusBlogWeb.ArticleView
  alias OlympusBlogWeb.TagView

  def render("index.json", %{articles: articles, hasMore: hasMore}) do
    %{
      articles: render_many(articles, ArticleView, "article.json"),
      hasMore: hasMore
    }
  end

  def render("show.json", %{article: article}) do
    render_one(article, ArticleView, "article.json")
  end

  def render("article.json", %{article: article}) do
    %{
      id: article.id,
      slug: article.slug,
      title: article.title,
      description: article.description,
      body: article.body,
      image: article.image,
      tagList: render_many(article.tagList, TagView, "tag.json"),
      favoritesCount: article.favorites |> Enum.count(),
      favorited:
        case article.favorited do
          nil -> false
          favorited -> favorited
        end,
      bookmarked:
        case article.bookmarked do
          nil -> false
          bookmarked -> bookmarked
        end,
      createdAt:
        article.inserted_at
        |> DateTime.truncate(:millisecond)
        |> DateTime.to_iso8601(:extended, 0),
      updatedAt:
        article.updated_at
        |> DateTime.truncate(:millisecond)
        |> DateTime.to_iso8601(:extended, 0),
      author: render_one(article.author, ArticleView, "author.json")
    }
  end

  def render("author.json", %{article: author}) do
    %{
      id: author.id,
      username: author.username,
      bio: author.bio,
      image: author.image,
      following:
        case author.following do
          nil -> false
          following -> following
        end,
      # TODO: Get count
      followers: 0,
      followee: 0
    }
  end
end
