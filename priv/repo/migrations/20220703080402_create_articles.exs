defmodule OlympusBlog.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :slug, :string, null: false
      add :title, :string, null: false
      add :description, :string, null: false
      add :body, :string, null: false
      add :image, :string
      add :author_id, references(:users)

      timestamps()
    end

    create unique_index(:articles, [:slug])
  end
end
