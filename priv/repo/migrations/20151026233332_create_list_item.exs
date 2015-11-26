defmodule FutureCyborg.Repo.Migrations.CreateListItem do
  use Ecto.Migration

  def change do
    create table(:list_items) do
      add :name, :string
      add :shopping_list_id, references(:shopping_lists)

      timestamps
    end
    create index(:list_items, [:shopping_list_id])

  end
end
