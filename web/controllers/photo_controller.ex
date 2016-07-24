defmodule WeddingWebsite.PhotoController do
  use WeddingWebsite.Web, :controller

  alias WeddingWebsite.Photo

  def delete(conn, %{"id" => id}) do
    photo = Repo.get!(Photo, id)

    Repo.delete!(photo)

    conn
    |> put_flash(:info, "Photo deleted successfully.")
    |> redirect(to: album_path(conn, :show, photo.album_id))
  end
end
