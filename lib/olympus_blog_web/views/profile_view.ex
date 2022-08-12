defmodule OlympusBlogWeb.ProfileView do
  use OlympusBlogWeb, :view
  alias OlympusBlogWeb.ProfileView

  def render("index.json", %{profiles: profiles}) do
    render_many(profiles, ProfileView, "profile.json", %{following: false})
  end

  def render("show.json", %{profile: profile, following: following}) do
    render_one(profile, ProfileView, "profile.json", %{following: following})
  end

  # TODO: Get followers, following, followee
  def render("profile.json", %{profile: profile, following: following}) do
    %{
      id: profile.id,
      username: profile.username,
      bio: profile.bio,
      image: profile.image,
      following: following,
      followers: 0,
      followee: 0
    }
  end
end
