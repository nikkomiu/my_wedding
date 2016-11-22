defmodule MyWedding.Repo.Migrations.UpdatePhotoReference do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE posts DROP CONSTRAINT IF EXISTS posts_photo_id_fkey"
    drop_if_exists index(:posts, [:photo_id])

    alter table(:posts) do
      modify :photo_id, references(:photos, on_delete: :nilify_all)
    end
  end
end
