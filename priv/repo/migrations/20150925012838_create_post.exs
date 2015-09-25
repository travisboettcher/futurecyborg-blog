defmodule HelloPhoenix.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :content, :string
      add :likes, :integer
      add :views, :integer
      add :user_id, references(:users)

      timestamps
    end
    create index(:posts, [:user_id])

  end
end
