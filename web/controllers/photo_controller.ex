defmodule MyWedding.PhotoController do
  use MyWedding.Web, :controller

  def delete(conn, %{"id" => id}) do
    photo = Repo.get!(MyWedding.Photo, id)

    Repo.delete!(photo)

    conn
    |> put_flash(:info, "Photo deleted successfully.")
    |> redirect(to: album_path(conn, :show, photo.album_id))
  end
end
