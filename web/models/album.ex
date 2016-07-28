defmodule MyWedding.Album do
  use MyWedding.Web, :model

  schema "albums" do
    field :title, :string
    field :description, :string
    field :is_public, :boolean

    has_many :photos, MyWedding.Photo, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description])
    |> validate_required([:title])
  end
end
