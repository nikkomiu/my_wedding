defmodule MyWedding.Repo.Migrations.AddIsPublicToAlbums do
  use Ecto.Migration

  def change do
    alter table(:albums) do
      add :is_public, :boolean, default: true
    end
  end
end
