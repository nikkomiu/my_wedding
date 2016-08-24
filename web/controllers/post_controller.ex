defmodule MyWedding.PostController do
  use MyWedding.Web, :controller

  alias MyWedding.Post

  plug :authorize_author, "user" when action in [:new, :create, :edit, :update]
  plug :authorize_manager, "user" when action in [:delete]

  def index(conn, _params) do
    post_query =
      from p in Post,
        order_by: p.order,
        order_by: p.inserted_at,
        preload: [:photo]

    posts =
      post_query
      |> pub_priv_query(conn)
      |> Repo.all()

    render(conn, :index, posts: posts)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{order: 0, is_active: true})
    render(conn, :new, changeset: changeset, photo_list: photo_list)
  end

  def create(conn, %{"post" => post_params}) do
    changeset = Post.changeset(%Post{}, post_params)

    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: post_path(conn, :show, post.id))
      {:error, changeset} ->
        render(conn, :new, changeset: changeset, photo_list: photo_list)
    end
  end

  def show(conn, %{"id" => id}) do
    post_query =
      from p in Post,
        where: p.id == ^id,
        preload: [:photo]

    post =
      post_query
      |> pub_priv_query(conn)
      |> Repo.one!()

    render(conn, :show, post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post)
    render(conn, :edit, post: post, changeset: changeset, photo_list: photo_list)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, changeset} ->
        conn
        |> render(conn, :edit, post: post, changeset: changeset, photo_list: photo_list)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end

  defp photo_list() do
    album_id =
      Repo.one(
        from a in MyWedding.Album,
          where: a.title == "Post Photos",
          select: a.id
      )

    Repo.all(
      from p in MyWedding.Photo,
        select: {p.path, p.id},
        where: p.album_id == ^album_id
    )
  end

  defp pub_priv_query(query, conn) do
    cond do
      is_authorized(conn, :author) ->
        query
      true ->
        from p in query,
          where: p.is_active == true
    end
  end
end
