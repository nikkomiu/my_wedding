defmodule WeddingWebsite.Router do
  use WeddingWebsite.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WeddingWebsite do
    pipe_through :browser

    get "/", PostController, :index

    resources "/pages", PostController

    resources "/albums", AlbumController
    get "/albums/:id/upload", AlbumController, :upload

    resources "/photos", PhotoController, only: [:show, :delete]
  end

  scope "/auth", WeddingWebsite do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/api", WeddingWebsite.Api do
    pipe_through :api

    resources "/photos", PhotoController, only: [:create]
  end
end
