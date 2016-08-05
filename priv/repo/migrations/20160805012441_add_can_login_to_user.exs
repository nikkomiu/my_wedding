defmodule MyWedding.Repo.Migrations.AddCanLoginToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :can_login, :boolean, default: true
    end
  end
end
