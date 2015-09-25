defmodule HelloPhoenix.Repo.Migrations.AlterEmailToString do
  use Ecto.Migration

  def up do
    alter table(:users) do
      modify :email, :string
    end
  end

  def down do
    alter table(:users) do
      modify :email, :text
    end
  end
end
