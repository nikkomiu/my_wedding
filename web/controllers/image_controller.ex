defmodule MyWedding.ImageController do
  use MyWedding.Web, :controller

  def upload(conn, %{"image_id" => image_id}) do
    [image_name, filetype] = String.split(image_id, ".")

    case String.split(image_name, "-") do
      [name, size] ->
        path = get_full_image_path(conn, "#{name}.#{filetype}")

        data = convert_image(path, size) |> File.read!()

        conn
        |> put_resp_header("Content-Type", "image/#{filetype}")
        |> send_resp(200, data)
      _ ->
        conn
        |> send_resp(404, "Image Not Found")
    end
  end
end
