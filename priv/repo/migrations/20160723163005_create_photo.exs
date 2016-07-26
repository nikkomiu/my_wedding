defmodule MyWedding.Repo.Migrations.CreatePhoto do
  use Ecto.Migration

  def change do
    create table(:photos) do
      add :path, :string

      add :album_id, references(:albums, on_delete: :delete_all)

      timestamps()
    end

    create index(:photos, [:album_id])
  end
end
