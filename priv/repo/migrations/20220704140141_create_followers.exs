defmodule OlympusBlog.Repo.Migrations.CreateFollowers do
  use Ecto.Migration

  def change do
    create table(:followers, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all), primary_key: true
      add :target_id, references(:users, on_delete: :delete_all), primary_key: true
    end

    create index(:followers, [:user_id])
    create index(:followers, [:target_id])
  end
end
