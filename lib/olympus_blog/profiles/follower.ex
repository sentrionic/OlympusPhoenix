defmodule OlympusBlog.Profiles.Follower do
  use Ecto.Schema
  import Ecto.Changeset

  alias OlympusBlog.Account.User

  @already_exists "ALREADY_EXISTS"

  @primary_key false
  schema "followers" do
    belongs_to(:user, User, primary_key: true)
    belongs_to(:target, User, primary_key: true)
  end

  @doc false
  def changeset(follower, attrs) do
    follower
    |> cast(attrs, [:user_id, :target_id])
    |> validate_required([:user_id, :target_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:target_id)
    |> unique_constraint([:user, :target],
      name: :user_id_target_id_unique_index,
      message: @already_exists
    )
  end
end
