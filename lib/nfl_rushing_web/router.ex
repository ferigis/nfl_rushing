defmodule NFL.RushingWeb.Router do
  use NFL.RushingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {NFL.RushingWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json", "csv"]
  end

  ## REST API

  scope "/api/v1", NFL.RushingWeb do
    pipe_through :api

    get "/players", PlayerController, :index
  end

  ## UI Page

  scope "/", NFL.RushingWeb do
    pipe_through :browser

    get "/", PageController, :index
  end
end
