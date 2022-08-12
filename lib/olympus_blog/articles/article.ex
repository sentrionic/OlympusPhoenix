defmodule OlympusBlog.Articles.Article do
  use Ecto.Schema
  import Ecto.Changeset

  alias OlympusBlog.Repo
  alias OlympusBlog.Account.User
  alias OlympusBlog.Articles.Tag
  alias OlympusBlog.Articles.ArticleTag
  alias OlympusBlog.Articles.Favorite
  alias OlympusBlog.Articles.Bookmark
  alias OlympusBlog.Comments.Comment

  schema "articles" do
    field :body, :string
    field :description, :string
    field :slug, :string
    field :title, :string
    field :image, :string
    belongs_to :author, User

    field :favorited, :boolean, virtual: true
    field :bookmarked, :boolean, virtual: true

    has_many :comments, Comment
    has_many :favorites, Favorite
    has_many :bookmarks, Bookmark

    many_to_many :tagList, Tag, join_through: ArticleTag, on_replace: :delete

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  # TODO: Add validation
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :description, :body, :author_id])
    |> cast_assoc(:author)
    |> put_assoc(:tagList, parse_tags(attrs))
    |> validate_required([:title, :description, :body])
    |> put_slug()
    |> unique_constraint(:slug)
    |> put_image()
  end

  def put_slug(changeset) do
    case get_change(changeset, :title) do
      nil -> changeset
      title -> put_change(changeset, :slug, slugify(title))
    end
  end

  defp slugify(title) do
    title |> String.downcase() |> String.replace(~r/[^\w-]+/u, "-") |> append_random_string(6)
  end

  defp parse_tags(params) do
    (params["tagList"] || params[:tagList] || [])
    |> Enum.map(&get_or_insert_tag/1)
  end

  defp get_or_insert_tag(name) do
    Repo.get_by(Tag, name: name) ||
      Repo.insert!(%Tag{name: name})
  end

  defp append_random_string(title, length) do
    s = for _ <- 1..length, into: "", do: <<Enum.random('0123456789abcdefghijklmnopqrstuvwxyz')>>
    title <> "-" <> s
  end

  # TODO: Upload File or get default one
  defp put_image(changeset) do
    changeset
  end
end
