defmodule HelloPhoenix.Repo.Migrations.AddEmailToUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :email, :text
    end
  end
end
