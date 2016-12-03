defmodule MyWedding.Repo.Migrations.AddProfessionalAlbums do
  use Ecto.Migration

  def change do
    alter table(:albums) do
      add :is_professional, :boolean, default: false
    end
  end
end
