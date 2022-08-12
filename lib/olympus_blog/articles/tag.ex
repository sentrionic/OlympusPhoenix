defmodule OlympusBlog.Articles.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  # TODO: Add validation
  schema "tags" do
    field :name

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
