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

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MyWedding do
    pipe_through :browser

    get "/", PostController, :index

    get "/sign-out", AuthController, :sign_out

    resources "/pages", PostController

    resources "/albums", AlbumController
    get "/albums/:id/upload", AlbumController, :upload

    resources "/photos", PhotoController, only: [:show, :delete]
  end

  scope "/auth", MyWedding do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/api", MyWedding.Api do
    pipe_through :api

    get "/health-check", HealthController, :health_check

    resources "/photos", PhotoController, only: [:create]
  end
end
