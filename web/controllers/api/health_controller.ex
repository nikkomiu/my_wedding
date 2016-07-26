defmodule MyWedding.Api.HealthController do
  use MyWedding.Web, :controller

  def health_check(conn, _params) do
    MyWedding.Repo.all(MyWedding.Post)

    conn
    |> json(%{status: "ok"})
  end
end
