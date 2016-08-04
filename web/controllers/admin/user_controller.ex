defmodule MyWedding.Admin.UserController do
  use MyWedding.Web, :controller

  alias MyWedding.Repo
  alias MyWedding.User

  def index(conn, _params) do
    users =
      Repo.all(User)

    conn
    |> render(:index, users: users)
  end

  def show(conn, %{"id" => id}) do
    user =
      Repo.get!(User, id)

    changeset = User.admin_changeset(user)

    conn
    |> render(:show, user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.admin_changeset(user, user_params)

    IO.inspect user_params

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset}
        conn
        |> render(conn, :show, user: user, changeset: changeset)
    end
  end
end
