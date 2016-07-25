defmodule MyWedding.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :body, :text
      add :order, :integer, default: 0
      add :is_active, :boolean, default: true, null: false

      add :photo_id, references(:photos, on_delete: :nothing)

      timestamps()
    end

    create index(:posts, [:photo_id])
  end
end
