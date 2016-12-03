defmodule MyWedding.Album do
  use MyWedding.Web, :model

  schema "albums" do
    field :title, :string
    field :description, :string
    field :is_public, :boolean
    field :is_professional, :boolean

    has_many :photos, MyWedding.Photo, on_delete: :delete_all

    timestamps()
  end

  def get_or_create_post_photos do
    album_query =
      from a in MyWedding.Album,
        where: a.title == "Post Photos",
        select: a.id

    changeset = MyWedding.Album.admin_changeset(%MyWedding.Album{}, %{title: "Post Photos", is_public: false})

    case MyWedding.Repo.one(album_query) || MyWedding.Repo.insert(changeset) do
      {:ok, album} ->
        album.id
      model ->
        model
    end
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :description, :is_public, :is_professional])
    |> validate_required([:title])
  end
end
