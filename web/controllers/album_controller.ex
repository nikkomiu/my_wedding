defmodule MyWedding.AlbumController do
  use MyWedding.Web, :controller

  alias MyWedding.Album

  plug :authorize_author, "user" when action in [:edit, :update]
  plug :authorize_manager, "user" when action in [:delete]

  def index(conn, _params) do
    photo_query =
      from p in MyWedding.Photo,
        order_by: [asc: :inserted_at]

    album_query =
      from a in Album,
        preload: [photos: ^photo_query]

    albums =
      album_query
      |> pub_priv_query(conn)
      |> Repo.all()

    render(conn, "index.html", albums: albums)
  end

  def new(conn, _params) do
    changeset = Album.changeset(%Album{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"album" => album_params}) do
    changeset = Album.changeset(%Album{}, album_params)

    case Repo.insert(changeset) do
      {:ok, _album} ->
        conn
        |> put_flash(:info, "Album created successfully.")
        |> redirect(to: album_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    photo_query =
      from p in MyWedding.Photo,
        order_by: [desc: :inserted_at]

    album_query =
      from a in Album,
        where: a.id == ^id,
        preload: [photos: ^photo_query]

    album =
      album_query
      |> pub_priv_query(conn)
      |> Repo.one!()

    render(conn, "show.html", album: album)
  end

  def edit(conn, %{"id" => id}) do
    album = Repo.get!(Album, id)
    changeset = Album.changeset(album)
    render(conn, "edit.html", album: album, changeset: changeset)
  end

  def update(conn, %{"id" => id, "album" => album_params}) do
    album = Repo.get!(Album, id)
    changeset = Album.admin_changeset(album, album_params)

    case Repo.update(changeset) do
      {:ok, album} ->
        conn
        |> put_flash(:info, "Album updated successfully.")
        |> redirect(to: album_path(conn, :show, album))
      {:error, changeset} ->
        render(conn, "edit.html", album: album, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    album = Repo.get!(Album, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(album)

    conn
    |> put_flash(:info, "Album deleted successfully.")
    |> redirect(to: album_path(conn, :index))
  end

  def upload(conn, %{"id" => id}) do
    album = Repo.get!(Album, id)

    changeset = MyWedding.Photo.changeset(%MyWedding.Photo{})

    render(conn, :upload, album: album, changeset: changeset)
  end

  def download(conn, %{"id" => id}) do
    photos = Repo.all(
      from p in MyWedding.Photo,
        where: p.album_id == ^id,
        select: struct(p, [:path, :inserted_at]),
        order_by: [desc: :inserted_at]
    )

    album_name = Repo.one!(
      from a in Album,
        where: a.id == ^id,
        select: a.title
    )

    inserted = (photos |> List.first()).inserted_at
      |> Ecto.DateTime.to_iso8601
      |> String.replace(":", "_")

    send_zip_name = "#{album_name} Album.zip"
    saved_zip_name = "#{id}-#{inserted}.zip"

    base_path = app_base(conn) |> Path.join("priv/static/uploads/")
    files = File.ls!(base_path)

    # If the current archive exists serve it otherwise create a new one
    if files |> Enum.any?(fn(x) -> x == saved_zip_name end) do
      conn
      |> send_binary_file(send_zip_name, File.read!(Path.join(base_path, saved_zip_name)))
    else
      # Remove the old zip file
      base_path
      |> Path.join(files |> Enum.find(fn(x) -> x |> String.starts_with?(id) end))
      |> File.rm()

      # Get the path of all of the photos
      photo_paths = Enum.map(photos, fn(p) -> p.path |> to_char_list end)

      # Zip the files
      case file_zip(base_path |> Path.join(saved_zip_name), photo_paths, base_path) do
        {:ok, _} ->
          conn
          |> send_binary_file(send_zip_name, File.read!(Path.join(base_path, saved_zip_name)))
        {:error, _} ->
          conn
          |> put_flash(:error, "Error creating archive of album!")
          |> redirect(to: album_path(conn, :show, id))
      end
    end
  end

  defp pub_priv_query(query, conn) do
    cond do
      is_authorized(conn, :uploader) ->
        query
      true ->
        from a in query,
          where: a.is_public == true
    end
  end
end
