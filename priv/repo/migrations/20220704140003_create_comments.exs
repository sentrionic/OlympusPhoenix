defmodule OlympusBlog.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :string
      add :author_id, references(:users, on_delete: :delete_all)
      add :article_id, references(:articles, on_delete: :delete_all)

      timestamps()
    end

    create index(:comments, [:author_id])
    create index(:comments, [:article_id])
  end
end
