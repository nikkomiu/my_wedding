defmodule MyWedding.Router do
  use MyWedding.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :admin do
    plug :authorize_admin
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MyWedding do
    pipe_through :browser

    get "/", PostController, :index

    resources "/pages", PostController

    resources "/albums", AlbumController
    get "/albums/:id/upload", AlbumController, :upload
    get "/albums/:id/download", AlbumController, :download
  end

  scope "/auth", MyWedding do
    pipe_through :browser

    get "/sign-in", AuthController, :sign_in
    get "/sign-out", AuthController, :sign_out

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/admin", MyWedding.Admin do
    pipe_through :browser
    pipe_through :admin

    get "/", HomeController, :index
    get "/download-photos", HomeController, :download_photos

    resources "/users", UserController, only: [:index, :show, :update, :delete]
  end

  scope "/api", MyWedding.Api do
    pipe_through :api

    get "/health-check", HealthController, :health_check

    resources "/photos", PhotoController, only: [:create, :delete]
  end
end
