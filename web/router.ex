defmodule Processor.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Processor do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/documents", DocumentController
    get "/documents/:id/process/:filename", DocumentController, :process, as: :process
  end

  # Other scopes may use custom stacks.
  # scope "/api", Processor do
  #   pipe_through :api
  # end
end
