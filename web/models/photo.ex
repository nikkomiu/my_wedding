defmodule MyWedding.Photo do
  use MyWedding.Web, :model

  schema "photos" do
    field :path, :string

    has_many :posts, MyWedding.Post
    belongs_to :album, MyWedding.Album

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
