defmodule MyWedding.Repo.Migrations.CreateAlbum do
  use Ecto.Migration

  def change do
    create table(:albums) do
      add :title, :string
      add :description, :text
      add :is_public, :boolean, default: true, null: false

      timestamps()
    end

  end
end
