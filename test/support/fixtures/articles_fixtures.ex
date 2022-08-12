defmodule OlympusBlog.ArticlesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OlympusBlog.Articles` context.
  """

  @doc """
  Generate a article.
  """
  def article_fixture(attrs \\ %{}) do
    {:ok, article} =
      attrs
      |> Enum.into(%{})
      |> OlympusBlog.Articles.create_article()

    article
  end

  @doc """
  Generate a tag.
  """
  def tag_fixture(attrs \\ %{}) do
    {:ok, tag} =
      attrs
      |> Enum.into(%{})
      |> OlympusBlog.Articles.create_tag()

    tag
  end

  @doc """
  Generate a article_tag.
  """
  def article_tag_fixture(attrs \\ %{}) do
    {:ok, article_tag} =
      attrs
      |> Enum.into(%{})
      |> OlympusBlog.Articles.create_article_tag()

    article_tag
  end

  @doc """
  Generate a favorite.
  """
  def favorite_fixture(attrs \\ %{}) do
    {:ok, favorite} =
      attrs
      |> Enum.into(%{})
      |> OlympusBlog.Articles.create_favorite()

    favorite
  end

  @doc """
  Generate a bookmark.
  """
  def bookmark_fixture(attrs \\ %{}) do
    {:ok, bookmark} =
      attrs
      |> Enum.into(%{})
      |> OlympusBlog.Articles.create_bookmark()

    bookmark
  end
end
