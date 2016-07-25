defmodule MyWedding.PhotoController do
  use MyWedding.Web, :controller

  alias MyWedding.Photo

  def delete(conn, %{"id" => id}) do
    photo = Repo.get!(Photo, id)

    Repo.delete!(photo)

    conn
    |> put_flash(:info, "Photo deleted successfully.")
    |> redirect(to: album_path(conn, :show, photo.album_id))
  end
end
