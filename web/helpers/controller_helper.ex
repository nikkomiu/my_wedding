defmodule MyWedding.ControllerHelper do
  import Plug.Conn

  def app_base(conn) do
    Application.app_dir(Phoenix.Controller.endpoint_module(conn).config(:otp_app))
  end

  def mem_zip(filename, files, base_path \\ "/") do
    :zip.create(filename, files, [:memory, {:cwd, base_path}])
  end

  def send_binary_file(conn, filename, data) do
    conn
    |> put_resp_header("Content-Type", "application/octet-stream")
    |> put_resp_header("Content-Disposition", "attachment; filename=\"#{filename}\"")
    |> resp(200, data)
  end
end
