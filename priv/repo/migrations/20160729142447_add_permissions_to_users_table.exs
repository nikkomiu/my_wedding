defmodule MyWedding.Repo.Migrations.AddPermissionsToUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :permission_level, :integer, default: 0
    end
  end
end
