defmodule MyWedding.AlbumController do
  use MyWedding.Web, :controller

  alias MyWedding.Album

  plug :authorize_author, "user" when action in [:edit, :update]
  plug :authorize_manager, "user" when action in [:delete]

  def index(conn, _params) do
    photo_query =
      from p in MyWedding.Photo,
        limit: 1

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

  def upload(conn, %{"id" => id}) do
    album = Repo.get!(Album, id)

    changeset = MyWedding.Photo.changeset(%MyWedding.Photo{})

    render(conn, :upload, album: album, changeset: changeset)
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
        order_by: p.inserted_at

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

  def download(conn, %{"id" => id}) do
    album_name = Repo.one!(
      from a in Album,
        where: a.id == ^id,
        select: a.title
    )

    photos = Repo.all(
      from p in MyWedding.Photo,
        where: p.album_id == ^id,
        select: p.path
    )

    base_path = Path.join([
      Application.app_dir(Phoenix.Controller.endpoint_module(conn).config(:otp_app)),
      "priv/static/uploads/",
    ])

    photo_paths = Enum.map(photos, fn(p) -> p |> to_char_list end)

    case :zip.create("#{album_name} Album.zip", photo_paths, [:cooked, :memory, {:cwd, base_path}]) do
      {:ok, {filename, data}} ->
        conn
        |> put_resp_header("Content-Type", "application/octet-stream")
        |> put_resp_header("Content-Disposition", "attachment; filename=\"#{filename}\"")
        |> put_resp_header("Location", album_path(conn, :show, id))
        |> resp(200, data)
      {:error, reason} ->
        conn
        |> redirect(to: album_path(conn, :show, id))
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
