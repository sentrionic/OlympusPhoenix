defmodule OlympusBlogWeb.CommentController do
  use OlympusBlogWeb, :controller

  alias OlympusBlog.Account
  alias OlympusBlog.Articles
  alias OlympusBlog.Articles.Article
  alias OlympusBlog.Comments
  alias OlympusBlog.Comments.Comment
  alias OlympusBlog.Repo

  action_fallback OlympusBlogWeb.FallbackController

  def list(conn, %{"slug" => slug}) do
    user = Account.get_user(get_session(conn, :user_id))

    comments = Comments.list_comment_by_article_slug(slug, user) |> Repo.preload(:author)
    render(conn, "list.json", comments: comments)
  end

  def create(conn, %{"slug" => slug, "body" => body}) do
    with user <- Account.get_user!(get_session(conn, :user_id)),
         %Article{} = article <- Articles.get_article_by_slug(slug),
         {:ok, comment} = Comments.create_comment(%{body: body}, article, user) do
      render(conn, "show.json", comment: comment |> Repo.preload(:author))
    end
  end

  def delete(conn, %{"slug" => _, "id" => comment_id}) do
    user_id = get_session(conn, :user_id)

    with %Comment{} = comment <- Comments.get_comment!(comment_id),
         ^user_id <- comment.author_id,
         {:ok, _} <- Comments.delete_comment(comment) do
      send_resp(conn, 200, "")
    end
  end
end
