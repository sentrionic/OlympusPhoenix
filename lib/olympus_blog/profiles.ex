defmodule OlympusBlog.Profiles do
  @moduledoc """
  The Profiles context.
  """

  import Ecto.Query, warn: false
  alias OlympusBlog.Repo

  alias OlympusBlog.Account.User
  alias OlympusBlog.Profiles.Follower

  # TODO: Add search term
  def list_profiles(_params) do
    Repo.all(User)
  end

  @doc """
  Gets a single follower.

  Raises `Ecto.NoResultsError` if the Follower does not exist.

  ## Examples

      iex> get_follower!(123)
      %Follower{}

      iex> get_follower!(456)
      ** (Ecto.NoResultsError)

  """
  def get_follower!(id), do: Repo.get!(Follower, id)

  def get_by_username!(username) do
    Repo.get_by!(User, username: username)
  end

  def following?(%User{} = user, %User{} = target) do
    Repo.get_by(Follower, user_id: user.id, target_id: target.id)
    |> is_nil()
    |> Kernel.not()
  end

  @doc """
  Creates a follower.

  ## Examples

      iex> create_follower(%{field: value})
      {:ok, %Follower{}}

      iex> create_follower(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_follower(%User{} = user, %User{} = target) do
    %Follower{}
    |> Follower.changeset(%{user_id: user.id, target_id: target.id})
    |> Repo.insert()
  end

  @doc """
  Deletes a follower.

  ## Examples

      iex> delete_follower(follower)
      {:ok, %Follower{}}

      iex> delete_follower(follower)
      {:error, %Ecto.Changeset{}}

  """
  def delete_follower(%User{} = user, %User{} = target) do
    q =
      from fr in Follower,
        where:
          fr.user_id == ^user.id and
            fr.target_id == ^target.id

    Repo.delete_all(q)
  end
end
