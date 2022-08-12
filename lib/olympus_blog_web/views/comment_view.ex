defmodule OlympusBlogWeb.CommentView do
  use OlympusBlogWeb, :view
  alias OlympusBlogWeb.CommentView

  alias OlympusBlog.Account.User
  alias OlympusBlog.Comments.Comment

  def render("list.json", %{comments: comments}) do
    render_many(comments, CommentView, "comment.json")
  end

  def render("show.json", %{comment: comment}) do
    render_one(comment, CommentView, "comment.json")
  end

  def render("comment.json", %{comment: %Comment{} = comment}) do
    %{
      id: comment.id,
      createdAt:
        comment.inserted_at
        |> DateTime.truncate(:millisecond)
        |> DateTime.to_iso8601(:extended, 0),
      updatedAt:
        comment.updated_at
        |> DateTime.truncate(:millisecond)
        |> DateTime.to_iso8601(:extended, 0),
      body: comment.body,
      author: render_one(comment.author, CommentView, "author.json", as: :author)
    }
  end

  def render("author.json", %{author: %User{} = author}) do
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
