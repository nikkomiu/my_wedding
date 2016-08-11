defmodule MyWedding.Post do
  use MyWedding.Web, :model

  schema "posts" do
    field :title, :string
    field :body, :string
    field :order, :integer
    field :is_active, :boolean, default: false

    belongs_to :photo, MyWedding.Photo

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body, :order, :is_active, :photo_id])
    |> validate_required([:title, :body])
  end
end
