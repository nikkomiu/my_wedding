defmodule WeddingWebsite.Photo do
  use WeddingWebsite.Web, :model

  schema "photos" do
    field :path, :string
    belongs_to :album, WeddingWebsite.Album

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:path])
    |> validate_required([:path])
  end
end
