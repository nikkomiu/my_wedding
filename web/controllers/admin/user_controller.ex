defmodule MyWedding.Admin.UserController do
  use MyWedding.Web, :controller

  alias MyWedding.User

  def index(conn, _params) do
    users = Repo.all(User)

    conn
    |> render(:index, users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    changeset = User.admin_changeset(user)

    conn
    |> render(:show, user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.admin_changeset(user, user_params)

    if user == current_user(conn) do
      conn
      |> put_flash(:error, "You can not modify yourself.")
      |> render(:show, user: user, changeset: changeset)
    else
      case Repo.update(changeset) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "User updated successfully.")
          |> redirect(to: user_path(conn, :show, user))
        {:error, changeset}
          conn
          |> render(:show, user: user, changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    if user == current_user(conn) do
      conn
      |> put_flash(:error, "You can not delete yourself.")
      |> redirect(to: user_path(conn, :show, user))
    else
      Repo.delete!(user)

      conn
      |> redirect(to: user_path(conn, :index))
    end
  end
end
