defmodule OlympusBlogWeb.ProfileController do
  use OlympusBlogWeb, :controller

  alias OlympusBlog.Account
  alias OlympusBlog.Account.User
  alias OlympusBlog.Profiles

  action_fallback OlympusBlogWeb.FallbackController

  def index(conn, params) do
    profiles = Profiles.list_profiles(params)

    render(conn, "index.json", profiles: profiles)
  end

  def show(conn, %{"username" => username}) do
    profile = Profiles.get_by_username!(username)

    following =
      case get_session(conn, :user_id) do
        nil -> false
        user_id -> Profiles.following?(Account.get_user!(user_id), profile)
      end

    render(conn, "show.json", profile: profile, following: following)
  end

  def follow(conn, %{"username" => username}) do
    user = Account.get_user!(get_session(conn, :user_id))

    with target_user <- Profiles.get_by_username!(username),
         {:ok, _} = Profiles.create_follower(user, target_user) do
      render(conn, "show.json", profile: target_user, following: true)
    end
  end

  def unfollow(conn, %{"username" => username}) do
    user = Account.get_user(get_session(conn, :user_id))

    with target_user <- Profiles.get_by_username!(username),
         {1, _} = Profiles.delete_follower(user, target_user) do
      render(conn, "show.json", profile: target_user, following: false)
    end
  end
end
