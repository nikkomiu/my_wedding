defmodule MyWedding.PhotoController do
  use MyWedding.Web, :controller

  require Logger

  plug :authorize_uploader, "user" when action in [:delete]

  def upload(conn, %{"file" => file_param, "id" => id}) do
    album = Repo.get!(MyWedding.Album, id)

    if album.is_professional && !is_authorized(conn, :uploader) do
      conn
      |> put_status(:unprocessable_entity)
      |> render(MyWedding.ErrorView, "422.json", %{"message" => "You are not authorized to do that!"})

      raise MyWedding.UserHelper.UnauthorizedError
    end

    # Get the content type base
    content_type =
      case Regex.named_captures(~r/(?<base_type>image|video)\/.*/, file_param.content_type) do
        %{"base_type" => type} ->
          type
        nil ->
          false
      end

    cond do
      recaptcha_verify(conn) == false ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(MyWedding.ErrorView, "422.json", %{"message" => "ReCAPTCHA Verification Failed"})

      content_type == false ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(MyWedding.ErrorView, "422.json", %{"message" => "File must be an image or video"})

      true ->
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
        if content_type == "image" do
          Task.async(fn ->
            convert_image(path, "800x500")
          end)
        end

        # Add to Album
        changeset = Ecto.build_assoc(album, :photos, %{path: filename, content_type: content_type})

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

  def verify(conn, %{"g-recaptcha-response" => recaptcha_response}) do
    res = MyWedding.Recaptcha.verify_response(recaptcha_response)

    Logger.info "reCAPTCHA Data: " <> (res.body |> String.replace("\n", "") |> String.replace("\n  ", ""))

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

  def unauthorized(conn, _) do
    conn
    |> put_status(:unauthorized)
    |> render(MyWedding.ErrorView, "401.json")
  end

  defp copy_temp_file(perm_path, temp_path) do
    File.cp!(temp_path, perm_path)
  end
end
