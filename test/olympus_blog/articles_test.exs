defmodule OlympusBlog.ArticlesTest do
  use OlympusBlog.DataCase

  alias OlympusBlog.Articles

  describe "articles" do
    alias OlympusBlog.Articles.Article

    import OlympusBlog.ArticlesFixtures

    @invalid_attrs %{}

    test "list_articles/0 returns all articles" do
      article = article_fixture()
      assert Articles.list_articles() == [article]
    end

    test "get_article!/1 returns the article with given id" do
      article = article_fixture()
      assert Articles.get_article!(article.id) == article
    end

    test "create_article/1 with valid data creates a article" do
      valid_attrs = %{}

      assert {:ok, %Article{} = article} = Articles.create_article(valid_attrs)
    end

    test "create_article/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Articles.create_article(@invalid_attrs)
    end

    test "update_article/2 with valid data updates the article" do
      article = article_fixture()
      update_attrs = %{}

      assert {:ok, %Article{} = article} = Articles.update_article(article, update_attrs)
    end

    test "update_article/2 with invalid data returns error changeset" do
      article = article_fixture()
      assert {:error, %Ecto.Changeset{}} = Articles.update_article(article, @invalid_attrs)
      assert article == Articles.get_article!(article.id)
    end

    test "delete_article/1 deletes the article" do
      article = article_fixture()
      assert {:ok, %Article{}} = Articles.delete_article(article)
      assert_raise Ecto.NoResultsError, fn -> Articles.get_article!(article.id) end
    end

    test "change_article/1 returns a article changeset" do
      article = article_fixture()
      assert %Ecto.Changeset{} = Articles.change_article(article)
    end
  end

  describe "tags" do
    alias OlympusBlog.Articles.Tag

    import OlympusBlog.ArticlesFixtures

    @invalid_attrs %{}

    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      assert Articles.list_tags() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Articles.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      valid_attrs = %{}

      assert {:ok, %Tag{} = tag} = Articles.create_tag(valid_attrs)
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Articles.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      update_attrs = %{}

      assert {:ok, %Tag{} = tag} = Articles.update_tag(tag, update_attrs)
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Articles.update_tag(tag, @invalid_attrs)
      assert tag == Articles.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Articles.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Articles.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Articles.change_tag(tag)
    end
  end

  describe "articles_tags" do
    alias OlympusBlog.Articles.ArticleTag

    import OlympusBlog.ArticlesFixtures

    @invalid_attrs %{}

    test "list_articles_tags/0 returns all articles_tags" do
      article_tag = article_tag_fixture()
      assert Articles.list_articles_tags() == [article_tag]
    end

    test "get_article_tag!/1 returns the article_tag with given id" do
      article_tag = article_tag_fixture()
      assert Articles.get_article_tag!(article_tag.id) == article_tag
    end

    test "create_article_tag/1 with valid data creates a article_tag" do
      valid_attrs = %{}

      assert {:ok, %ArticleTag{} = article_tag} = Articles.create_article_tag(valid_attrs)
    end

    test "create_article_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Articles.create_article_tag(@invalid_attrs)
    end

    test "update_article_tag/2 with valid data updates the article_tag" do
      article_tag = article_tag_fixture()
      update_attrs = %{}

      assert {:ok, %ArticleTag{} = article_tag} =
               Articles.update_article_tag(article_tag, update_attrs)
    end

    test "update_article_tag/2 with invalid data returns error changeset" do
      article_tag = article_tag_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Articles.update_article_tag(article_tag, @invalid_attrs)

      assert article_tag == Articles.get_article_tag!(article_tag.id)
    end

    test "delete_article_tag/1 deletes the article_tag" do
      article_tag = article_tag_fixture()
      assert {:ok, %ArticleTag{}} = Articles.delete_article_tag(article_tag)
      assert_raise Ecto.NoResultsError, fn -> Articles.get_article_tag!(article_tag.id) end
    end

    test "change_article_tag/1 returns a article_tag changeset" do
      article_tag = article_tag_fixture()
      assert %Ecto.Changeset{} = Articles.change_article_tag(article_tag)
    end
  end

  describe "favorites" do
    alias OlympusBlog.Articles.Favorite

    import OlympusBlog.ArticlesFixtures

    @invalid_attrs %{}

    test "list_favorites/0 returns all favorites" do
      favorite = favorite_fixture()
      assert Articles.list_favorites() == [favorite]
    end

    test "get_favorite!/1 returns the favorite with given id" do
      favorite = favorite_fixture()
      assert Articles.get_favorite!(favorite.id) == favorite
    end

    test "create_favorite/1 with valid data creates a favorite" do
      valid_attrs = %{}

      assert {:ok, %Favorite{} = favorite} = Articles.create_favorite(valid_attrs)
    end

    test "create_favorite/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Articles.create_favorite(@invalid_attrs)
    end

    test "update_favorite/2 with valid data updates the favorite" do
      favorite = favorite_fixture()
      update_attrs = %{}

      assert {:ok, %Favorite{} = favorite} = Articles.update_favorite(favorite, update_attrs)
    end

    test "update_favorite/2 with invalid data returns error changeset" do
      favorite = favorite_fixture()
      assert {:error, %Ecto.Changeset{}} = Articles.update_favorite(favorite, @invalid_attrs)
      assert favorite == Articles.get_favorite!(favorite.id)
    end

    test "delete_favorite/1 deletes the favorite" do
      favorite = favorite_fixture()
      assert {:ok, %Favorite{}} = Articles.delete_favorite(favorite)
      assert_raise Ecto.NoResultsError, fn -> Articles.get_favorite!(favorite.id) end
    end

    test "change_favorite/1 returns a favorite changeset" do
      favorite = favorite_fixture()
      assert %Ecto.Changeset{} = Articles.change_favorite(favorite)
    end
  end

  describe "bookmarks" do
    alias OlympusBlog.Articles.Bookmark

    import OlympusBlog.ArticlesFixtures

    @invalid_attrs %{}

    test "list_bookmarks/0 returns all bookmarks" do
      bookmark = bookmark_fixture()
      assert Articles.list_bookmarks() == [bookmark]
    end

    test "get_bookmark!/1 returns the bookmark with given id" do
      bookmark = bookmark_fixture()
      assert Articles.get_bookmark!(bookmark.id) == bookmark
    end

    test "create_bookmark/1 with valid data creates a bookmark" do
      valid_attrs = %{}

      assert {:ok, %Bookmark{} = bookmark} = Articles.create_bookmark(valid_attrs)
    end

    test "create_bookmark/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Articles.create_bookmark(@invalid_attrs)
    end

    test "update_bookmark/2 with valid data updates the bookmark" do
      bookmark = bookmark_fixture()
      update_attrs = %{}

      assert {:ok, %Bookmark{} = bookmark} = Articles.update_bookmark(bookmark, update_attrs)
    end

    test "update_bookmark/2 with invalid data returns error changeset" do
      bookmark = bookmark_fixture()
      assert {:error, %Ecto.Changeset{}} = Articles.update_bookmark(bookmark, @invalid_attrs)
      assert bookmark == Articles.get_bookmark!(bookmark.id)
    end

    test "delete_bookmark/1 deletes the bookmark" do
      bookmark = bookmark_fixture()
      assert {:ok, %Bookmark{}} = Articles.delete_bookmark(bookmark)
      assert_raise Ecto.NoResultsError, fn -> Articles.get_bookmark!(bookmark.id) end
    end

    test "change_bookmark/1 returns a bookmark changeset" do
      bookmark = bookmark_fixture()
      assert %Ecto.Changeset{} = Articles.change_bookmark(bookmark)
    end
  end
end
