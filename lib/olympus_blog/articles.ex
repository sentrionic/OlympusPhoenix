defmodule OlympusBlog.Articles do
  @moduledoc """
  The Articles context.
  """

  import Ecto.Query, warn: false
  alias OlympusBlog.Repo

  alias OlympusBlog.Account.User
  alias OlympusBlog.Articles.Article
  alias OlympusBlog.Articles.Favorite
  alias OlympusBlog.Articles.Bookmark
  alias OlympusBlog.Articles.Tag
  alias OlympusBlog.Profiles.Follower

  @default_limit 20
  @default_offset 0

  def article_preload(article_or_articles) do
    article_or_articles
    |> Repo.preload(:author)
    |> Repo.preload(:favorites)
    |> Repo.preload(:bookmarks)
    |> Repo.preload(:tagList)
  end

  @doc """
  Returns the list of articles.
  """
  # TODO: Get HasMore
  # TODO: Order
  # TODO: Cursor
  def list_articles(params \\ []) do
    {limit, params} = params |> Keyword.pop(:limit, @default_limit)
    {offset, params} = params |> Keyword.pop(:offset, @default_offset)

    from(a in Article)
    |> article_where(params)
    |> limit(^limit)
    |> offset(^offset)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def list_articles_feed(user, params \\ []) do
    {limit, params} = params |> Keyword.pop(:limit, @default_limit)
    {offset, _} = params |> Keyword.pop(:offset, @default_offset)

    from(a in Article,
      inner_join: f in Favorite,
      on: a.id == f.article_id,
      where: f.user_id == ^user.id,
      limit: ^limit,
      offset: ^offset
    )
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def article_where(query, []), do: query

  def article_where(query, [{:tag, tag} | rest]) do
    query
    |> join(:left, [a], at in assoc(a, :tagList), as: :tags)
    |> where([tags: tags], tags.name == ^tag)
    |> article_where(rest)
  end

  def article_where(query, [{:author, author_name} | rest]) do
    query
    |> join(:inner, [a], author in User, as: :author, on: a.author_id == author.id)
    |> where([author: author], author.username == ^author_name)
    |> article_where(rest)
  end

  def article_where(query, [{:favorited, favorited} | rest]) do
    query
    |> join(:left, [a], f in Favorite, as: :favorite, on: a.id == f.article_id)
    |> join(:left, [favorite: f], fu in User, as: :favorite_user, on: f.user_id == fu.id)
    |> where([favorite_user: fu], fu.username == ^favorited)
    |> article_where(rest)
  end

  def article_where(query, [{:user, %User{} = user} | rest]) do
    article_favorite(query, user)
    |> article_where(rest)
  end

  def article_where(query, _), do: query

  def article_favorite(query, nil), do: query

  def article_favorite(query, user) do
    query
    |> join(:left, [a], f in Favorite,
      as: :myfavorite,
      on: a.id == f.article_id and f.user_id == ^user.id
    )
    |> select_merge([myfavorite: f], %{favorited: not is_nil(f)})
  end

  @doc """
  Gets a single article.

  Raises `Ecto.NoResultsError` if the Article does not exist.

  ## Examples

      iex> get_article!(123)
      %Article{}

      iex> get_article!(456)
      ** (Ecto.NoResultsError)

  """
  def get_article!(id), do: Repo.get!(Article, id)

  def get_article_by_slug(slug, user \\ nil) do
    article =
      get_article_by_slug_query(slug, user)
      |> Repo.one()

    unless is_nil(article), do: article, else: {:error, :not_found}
  end

  defp get_article_by_slug_query(slug, user) do
    from(a in Article, where: a.slug == ^slug)
    |> article_favorite(user)
  end

  @doc """
  Creates a article.

  ## Examples

      iex> create_article(%{field: value})
      {:ok, %Article{}}

      iex> create_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_article(attrs \\ %{}) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a article.

  ## Examples

      iex> update_article(article, %{field: new_value})
      {:ok, %Article{}}

      iex> update_article(article, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_article(%Article{} = article, attrs) do
    article
    |> Repo.preload(:tagList)
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a article.

  ## Examples

      iex> delete_article(article)
      {:ok, %Article{}}

      iex> delete_article(article)
      {:error, %Ecto.Changeset{}}

  """
  def delete_article(%Article{} = article) do
    Repo.delete(article)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking article changes.

  ## Examples

      iex> change_article(article)
      %Ecto.Changeset{data: %Article{}}

  """
  def change_article(%Article{} = article, attrs \\ %{}) do
    Article.changeset(article, attrs)
  end

  def create_favorite(%User{} = user, %Article{} = article) do
    %Favorite{}
    |> Favorite.changeset(%{user_id: user.id, article_id: article.id})
    |> Repo.insert()
  end

  def delete_favorite(%User{} = user, %Article{} = article) do
    from(f in Favorite,
      where:
        f.user_id == ^user.id and
          f.article_id ==
            ^article.id
    )
    |> Repo.delete_all()
  end

  def create_bookmark(%User{} = user, %Article{} = article) do
    %Bookmark{}
    |> Bookmark.changeset(%{user_id: user.id, article_id: article.id})
    |> Repo.insert()
  end

  def delete_bookmark(%User{} = user, %Article{} = article) do
    from(b in Bookmark,
      where:
        b.user_id == ^user.id and
          b.article_id ==
            ^article.id
    )
    |> Repo.delete_all()
  end

  @doc """
  Returns the list of tags.

  ## Examples

      iex> list_tags()
      [%Tag{}, ...]

  """
  def list_tags do
    Repo.all(Tag)
  end
end
