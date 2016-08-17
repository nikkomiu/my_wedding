defmodule MyWedding.Api.PhotoController do
  use MyWedding.Web, :controller

  require Logger

  def create(conn, %{"file" => file_param, "album_id" => album_id}) do
    if Regex.match?(~r/image\/.*/, file_param.content_type) do
      # Get the filename to save to
      uuid =
        Ecto.UUID.generate
        |> String.replace("-", "")
        |> String.slice(1..10)

      filename = "#{uuid}.#{List.last(String.split(file_param.filename, "."))}"

      path = get_full_image_path(conn, filename)

      # Copy the full size file into place
      path
      |> copy_temp_file(file_param.path)

      # Async Convert Image
      Task.async(fn ->
        convert_image(path, "800x500")
      end)

      # Insert Image
      album = Repo.get!(MyWedding.Album, album_id)
      changeset = Ecto.build_assoc(album, :photos, path: filename)

      case Repo.insert(changeset) do
        {:ok, _} ->
          conn
          |> put_status(:created)
          |> render(MyWedding.ChangesetView, "success.json")
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(MyWedding.ChangesetView, "error.json", changeset: changeset)
      end
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(MyWedding.ErrorView, "422.json")
    end
  end

  def delete(conn, %{"id" => id}) do
    photo = Repo.get!(MyWedding.Photo, id)

    path = get_full_image_path(conn, "#{photo.path}")
    get_size_image_path_from_full_path(path, "800x500") |> File.rm()

    case path |> File.rm() do
      {:error, status} when status != :enoent ->
        raise("Could not delete file! #{status}")
      _ ->
        Repo.delete!(photo)
    end

    conn
    |> redirect(to: album_path(conn, :show, photo.album_id))
  end

  defp copy_temp_file(perm_path, temp_path) do
    File.cp!(temp_path, perm_path)
  end
end
