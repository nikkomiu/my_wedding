defmodule MyWedding.Api.PhotoController do
  use MyWedding.Web, :controller

  def create(conn, %{"file" => file_param, "album_id" => album_id}) do
    if Regex.match?(~r/image\/.*/, file_param.content_type) do
      # Get the filename to save to
      filename = "#{Ecto.UUID.generate}.#{List.last(String.split(file_param.filename, "."))}"

      # Copy the file into place
      get_full_path(conn, filename)
      |> copy_temp_file(file_param.path)

      album = Repo.get!(MyWedding.Album, album_id)
      changeset = Ecto.build_assoc(album, :photos, path: filename)

      case Repo.insert(changeset) do
        {:ok, photo} ->
          conn
          |> put_status(:created)
          |> put_resp_header("location", photo_path(conn, :show, photo))
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

  defp get_full_path(conn, filename) do
    Application.app_dir(Phoenix.Controller.endpoint_module(conn).config(:otp_app))
    |> Path.join("/priv/static/uploads/#{filename}")
  end

  defp copy_temp_file(perm_path, temp_path) do
    File.cp!(temp_path, perm_path)
  end
end
