defmodule MyWedding.Admin.HomeController do
  use MyWedding.Web, :controller

  alias MyWedding.Repo

  def index(conn, _params) do
    user_count =
      Repo.one(
        from u in MyWedding.User,
          select: count(u.id))

    conn
    |> render(:index, user_count: user_count)
  end
end
