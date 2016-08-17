defmodule MyWedding.PageController do
  use MyWedding.Web, :controller

  def terms(conn, _params) do
    conn
    |> render(:terms)
  end
end
