defmodule MyWedding.ControllerHelper do
<<<<<<< HEAD
  import Plug.Conn
=======

  import Plug.Conn
  import Mogrify
>>>>>>> ea297328f3042e8d4613d6bcd48e3263e45fb36f

  def app_base(conn) do
    Application.app_dir(Phoenix.Controller.endpoint_module(conn).config(:otp_app))
  end

  def get_photo_archive(base_path, saved_zip_name, photos) do
    files = File.ls!(base_path)

    # If the current archive exists serve it otherwise create a new one
    if files |> Enum.any?(fn(x) -> x == saved_zip_name end) do
      {:ok, read_zip(base_path, saved_zip_name)}
    else
      # ID part of the filename to remove
      id = saved_zip_name |> String.split("-") |> List.first()

      # Remove the old zip file
      case files |> Enum.find(fn(x) -> x |> String.starts_with?(id) end) do
        nil ->
          nil
        file ->
          base_path
          |> Path.join(file)
          |> File.rm()
      end

      # Get the path of all of the photos
      photo_paths = Enum.map(photos, fn(p) -> p.path |> to_char_list end)

      # Zip the files
      case file_zip(base_path |> Path.join(saved_zip_name), photo_paths, base_path) do
        {:ok, _} ->
          {:ok, read_zip(base_path, saved_zip_name)}
        match ->
          match
      end
    end
  end

  def newest_photo_date(photo) do
    photo.inserted_at
    |> Ecto.DateTime.to_iso8601
    |> String.replace(":", "_")
  end

  defp read_zip(base_path, filename) do
    base_path
    |> Path.join(filename)
    |> File.read!()
  end

  def file_zip(filename, files, base_path \\ "/") do
    :zip.create(filename, files, [{:cwd, base_path}])
  end

  def send_binary_file(conn, filename, data) do
    conn
    |> put_resp_header("Content-Type", "application/octet-stream")
    |> put_resp_header("Content-Disposition", "attachment; filename=\"#{filename}\"")
    |> resp(200, data)
  end
<<<<<<< HEAD
=======

  def convert_image(path, size) do
    image =
      path
      |> open()
      |> auto_orient()
      |> resize_to_limit(size)
      |> save()

    image.path
    |> File.cp!(get_size_image_path_from_full_path(path, size))

    image.path
  end

  def get_full_image_path(conn, filename) do
    Application.app_dir(Phoenix.Controller.endpoint_module(conn).config(:otp_app))
    |> Path.join("/priv/static/uploads/#{filename}")
  end

  def get_size_image_path_from_full_path(orig_path, size) do
    split_path =
      orig_path
      |> String.split(".")

    split_path
    |> List.replace_at(length(split_path) -2, Enum.join([List.first(Enum.take(split_path, -2)), size], "-"))
    |> Enum.join(".")
  end

  def recaptcha_verify(conn) do
    recaptcha_session = get_session(conn, :recaptcha)
    MyWedding.UserHelper.current_user(conn) != nil || (recaptcha_session && recaptcha_session.success)
  end
>>>>>>> ea297328f3042e8d4613d6bcd48e3263e45fb36f
end
