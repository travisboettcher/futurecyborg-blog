defmodule FutureCyborg.Repo.Migrations.CreateShoppingList do
  use Ecto.Migration

  def change do
    create table(:shopping_lists) do
      add :name, :string
      add :user_id, references(:users)

      timestamps
    end
    create index(:shopping_lists, [:user_id])

  end
end
