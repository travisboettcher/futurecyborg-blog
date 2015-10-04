defmodule HelloPhoenix.Router do
  use HelloPhoenix.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authenticated do
    plug HelloPhoenix.Authenticator
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HelloPhoenix do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "login", LoginController, :index
    post "login", LoginController, :login
    get "logout", LoginController, :logout
    post "signup", LoginController, :signup
    resources "posts", PostController, only: [:show]

    scope "/" do
      pipe_through :authenticated

      resources "users", UserController
      resources "posts", PostController, except: [:show]
    end
  end

  # Other scopes may use custom stacks.
  scope "/api", HelloPhoenix do
    pipe_through :api

    resources "users", API.UserController, only: [:show, :index]
  end
end
