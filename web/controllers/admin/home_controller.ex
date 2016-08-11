defmodule MyWedding.Admin.HomeController do
  use MyWedding.Web, :controller

  def index(conn, _params) do
    user_count =
      Repo.one(
        from u in MyWedding.User,
          select: count(u.id))

    post_count =
      Repo.one(
        from p in MyWedding.Post,
          select: count(p.id)
      )

    photo_count =
      Repo.one(
        from p in MyWedding.Photo,
          select: count(p.id)
      )

    album_count =
      Repo.one(
        from p in MyWedding.Album,
          select: count(p.id)
      )

    conn
    |> render(:index, user_count: user_count, post_count: post_count, album_count: album_count, photo_count: photo_count)
  end
end
