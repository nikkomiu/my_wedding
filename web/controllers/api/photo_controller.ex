defmodule MyWedding.Api.PhotoController do
  use MyWedding.Web, :controller

  require Logger
<<<<<<< HEAD
  import Mogrify
=======
>>>>>>> ea297328f3042e8d4613d6bcd48e3263e45fb36f

  plug :authorize_uploader, "user" when action in [:delete]

  def upload(conn, %{"file" => file_param, "id" => id}) do
    if recaptcha_verify(conn) && Regex.match?(~r/image\/.*/, file_param.content_type) do
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

<<<<<<< HEAD
      # Convert Image
=======
      # Async Convert Image
>>>>>>> ea297328f3042e8d4613d6bcd48e3263e45fb36f
      Task.async(fn ->
        convert_image(path, "800x500")
      end)
      # End Convert Image

      # Insert Image
<<<<<<< HEAD
      album = Repo.get!(MyWedding.Album, album_id)
=======
      album = Repo.get!(MyWedding.Album, id)
>>>>>>> ea297328f3042e8d4613d6bcd48e3263e45fb36f
      changeset = Ecto.build_assoc(album, :photos, path: filename)

      case Repo.insert(changeset) do
        {:ok, _} ->
          conn
          |> put_status(:created)
          |> render(MyWedding.ChangesetView, "success.json")
        {:error, changeset} ->
          # TODO: Delete files

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

<<<<<<< HEAD
    Repo.delete!(photo)

    conn
    |> redirect(to: album_path(conn, :show, photo.album_id))
  end
  
  defp get_full_path(conn, filename) do
    Application.app_dir(Phoenix.Controller.endpoint_module(conn).config(:otp_app))
    |> Path.join("/priv/static/uploads/#{filename}")
=======
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
>>>>>>> ea297328f3042e8d4613d6bcd48e3263e45fb36f
  end

  def verify(conn, %{"g-recaptcha-response" => recaptcha_response}) do
    res = MyWedding.Recaptcha.verify_response(recaptcha_response)

    Logger.info "ReCAPTCHA Data: " <> (res.body |> String.replace("\n", "") |> String.replace("\n  ", ""))

    data = Poison.decode!(res.body, as: %MyWedding.Recaptcha{})

    if data.success == true do
      conn
      |> fetch_session(:recaptcha)
      |> put_session(:recaptcha, data)
      |> resp(200, "")
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(MyWedding.ErrorView, "422.json")
    end
  end

<<<<<<< HEAD
    split_path
    |> List.replace_at(length(split_path) -2, Enum.join([List.first(Enum.take(split_path, -2)), size], "-"))
    |> Enum.join(".")
=======
  def unauthorized(conn, _) do
    conn
    |> put_status(:unauthorized)
    |> render(MyWedding.ErrorView, "401.json")
>>>>>>> ea297328f3042e8d4613d6bcd48e3263e45fb36f
  end

  defp copy_temp_file(perm_path, temp_path) do
    File.cp!(temp_path, perm_path)
  end
end
