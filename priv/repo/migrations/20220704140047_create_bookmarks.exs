defmodule OlympusBlog.Repo.Migrations.CreateBookmarks do
  use Ecto.Migration

  def change do
    create table(:bookmarks, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all), primary_key: true
      add :article_id, references(:articles, on_delete: :delete_all), primary_key: true
    end

    create index(:bookmarks, [:user_id])
    create index(:bookmarks, [:article_id])
  end
end
