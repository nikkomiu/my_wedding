defmodule MyWedding.Post do
  use MyWedding.Web, :model

  schema "posts" do
    field :title, :string
    field :body, :string
    field :order, :integer
    field :is_active, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body, :order, :is_active])
    |> validate_required([:title, :body])
  end
end
