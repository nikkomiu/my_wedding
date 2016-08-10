defmodule MyWedding.AuthController do
  use MyWedding.Web, :controller

  alias MyWedding.User

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to log in.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case User.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully logged in.")
        |> configure_session(renew: true)
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: "/")
      {:error, "User is inactive"} ->
        conn
        |> put_flash(:error, "Your account is not active. Please contact the site administrator to activate your account.")
        |> redirect(to: "/")
      {:error, reason} ->
        conn
        |> put_flash(:error, "Could not log you in! Please contact the site admin if the problem persists.")
        |> redirect(to: "/")
    end
  end

  def sign_in(conn, _params) do
    conn
    |> render(:sign_in)
  end

  def sign_out(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end
end
