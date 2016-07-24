defmodule WeddingWebsite.Api.PhotoController do
  use WeddingWebsite.Web, :controller

  require Logger

  alias WeddingWebsite.Photo

  def create(conn, %{"file" => file_param, "album_id" => album_id}) do
    # TODO: Verify the filetype

    # Get the filename to save to
    filename = get_save_filename(file_param.filename)

    # Copy the file into place
    get_full_path(conn, filename)
    |> copy_temp_file(file_param.path)

    album = Repo.get!(WeddingWebsite.Album, album_id)
    changeset = Ecto.build_assoc(album, :photos, path: filename)

    case Repo.insert(changeset) do
      {:ok, photo} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", photo_path(conn, :show, photo))
        |> render(WeddingWebsite.ChangesetView, "success.json")
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(WeddingWebsite.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp get_save_filename(filename) do
    "#{Ecto.UUID.generate}.#{List.last(String.split(filename, "."))}"
  end

  defp get_full_path(conn, filename) do
    Application.app_dir(Phoenix.Controller.endpoint_module(conn).config(:otp_app))
    |> Path.join("/priv/static/uploads/#{filename}")
  end

  defp copy_temp_file(perm_path, temp_path) do
    case File.cp(temp_path, perm_path) do
      :ok ->
        perm_path
      {:error, msg} ->
        Logger.error msg
        nil
    end
  end
end
