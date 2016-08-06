defmodule MyWedding.Album do
  use MyWedding.Web, :model

  schema "albums" do
    field :title, :string
    field :description, :string
    field :is_public, :boolean

    has_many :photos, MyWedding.Photo, on_delete: :delete_all

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description])
    |> validate_required([:title])
  end

  def admin_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast(params, [:is_public])
  end
end
