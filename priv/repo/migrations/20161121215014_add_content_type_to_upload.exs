defmodule MyWedding.Repo.Migrations.AddContentTypeToUpload do
  use Ecto.Migration

  def change do
    alter table(:photos) do
      add :content_type, :string, default: "image"
    end
  end
end
