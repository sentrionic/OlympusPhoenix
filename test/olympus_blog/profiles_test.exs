defmodule OlympusBlog.ProfilesTest do
  use OlympusBlog.DataCase

  alias OlympusBlog.Profiles

  describe "followers" do
    alias OlympusBlog.Profiles.Follower

    import OlympusBlog.ProfilesFixtures

    @invalid_attrs %{}

    test "list_followers/0 returns all followers" do
      follower = follower_fixture()
      assert Profiles.list_followers() == [follower]
    end

    test "get_follower!/1 returns the follower with given id" do
      follower = follower_fixture()
      assert Profiles.get_follower!(follower.id) == follower
    end

    test "create_follower/1 with valid data creates a follower" do
      valid_attrs = %{}

      assert {:ok, %Follower{} = follower} = Profiles.create_follower(valid_attrs)
    end

    test "create_follower/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Profiles.create_follower(@invalid_attrs)
    end

    test "update_follower/2 with valid data updates the follower" do
      follower = follower_fixture()
      update_attrs = %{}

      assert {:ok, %Follower{} = follower} = Profiles.update_follower(follower, update_attrs)
    end

    test "update_follower/2 with invalid data returns error changeset" do
      follower = follower_fixture()
      assert {:error, %Ecto.Changeset{}} = Profiles.update_follower(follower, @invalid_attrs)
      assert follower == Profiles.get_follower!(follower.id)
    end

    test "delete_follower/1 deletes the follower" do
      follower = follower_fixture()
      assert {:ok, %Follower{}} = Profiles.delete_follower(follower)
      assert_raise Ecto.NoResultsError, fn -> Profiles.get_follower!(follower.id) end
    end

    test "change_follower/1 returns a follower changeset" do
      follower = follower_fixture()
      assert %Ecto.Changeset{} = Profiles.change_follower(follower)
    end
  end
end
