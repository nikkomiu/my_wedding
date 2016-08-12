defmodule MyWedding.Api.PhotoController do
  use MyWedding.Web, :controller

  require Logger
  import Mogrify

  def create(conn, %{"file" => file_param, "album_id" => album_id}) do
    if Regex.match?(~r/image\/.*/, file_param.content_type) do
      # Get the filename to save to
      uuid =
        Ecto.UUID.generate
        |> String.replace("-", "")
        |> String.slice(1..10)

      filename = "#{uuid}.#{List.last(String.split(file_param.filename, "."))}"

      path = get_full_path(conn, filename)

      # Copy the full size file into place
      path
      |> copy_temp_file(file_param.path)

      # Convert Image
      Task.async(fn ->
        size = "800x500"

        image =
          path
          |> when_image_exists()
          |> open()
          |> resize_to_fill(size)
          |> save()

        image.path
        |> File.cp!(get_size_path_from_full_path(path, size))
      end)
      # End Convert Image

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

    Repo.delete!(photo)

    conn
    |> redirect(to: album_path(conn, :show, photo.album_id))
  end

  defp when_image_exists(path) do
    Logger.debug "Checking for image..."

    unless File.exists?(path) do
      Logger.warn "Image doesn't exist yet"

      :timer.sleep(10)
      when_image_exists(path)
    end

    path
  end

  defp get_full_path(conn, filename) do
    Application.app_dir(Phoenix.Controller.endpoint_module(conn).config(:otp_app))
    |> Path.join("/priv/static/uploads/#{filename}")
  end

  defp get_size_path_from_full_path(orig_path, size) do
    split_path =
      orig_path
      |> String.split(".")

    split_path
    |> List.replace_at(length(split_path) -2, Enum.join([List.first(Enum.take(split_path, -2)), size], "-"))
    |> Enum.join(".")
  end

  defp copy_temp_file(perm_path, temp_path) do
    File.cp!(temp_path, perm_path)
  end
end
