defmodule MyWedding.Admin.HomeController do
  use MyWedding.Web, :controller

  def index(conn, _params) do
    IO.inspect "-=-=-=-=-=-=-=-=-=-=- Oh shat"
    user_count =
      Repo.one(
        from u in MyWedding.User,
          select: count(u.id))

    post_count =
      Repo.one(
        from p in MyWedding.Post,
          select: count(p.id)
      )

    photo_count =
      Repo.one(
        from p in MyWedding.Photo,
          select: count(p.id)
      )

    album_count =
      Repo.one(
        from p in MyWedding.Album,
          select: count(p.id)
      )

    conn
    |> render(:index, user_count: user_count, post_count: post_count, album_count: album_count, photo_count: photo_count)
  end

  def download_photos(conn, _params) do
    photos = Repo.all(
      from p in MyWedding.Photo,
        select: struct(p, [:path, :inserted_at]),
        order_by: [desc: :inserted_at]
    )

    newest_inserted =
      photos
      |> List.first()
      |> newest_photo_date()

    base_path = app_base(conn) |> Path.join("priv/static/uploads/")
    send_filename = "All Photos.zip"

    case get_photo_archive(base_path, "admin-#{newest_inserted}.zip", photos) do
      {:ok, data} ->
        conn
        |> send_binary_file(send_filename, data)
      {:error, _} ->
        conn
        |> put_flash(:error, "Error creating archive!")
        |> redirect(to: home_path(conn, :index))
     end
  end
end
