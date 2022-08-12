defmodule OlympusBlog.ProfilesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OlympusBlog.Profiles` context.
  """

  @doc """
  Generate a follower.
  """
  def follower_fixture(attrs \\ %{}) do
    {:ok, follower} =
      attrs
      |> Enum.into(%{})
      |> OlympusBlog.Profiles.create_follower()

    follower
  end
end
