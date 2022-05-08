defmodule ChatterWeb.Router do
  use ChatterWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ChatterWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ChatterWeb.Plugs.AssignGitRev
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticate do
    plug ChatterWeb.Plugs.RequireAuth
  end

  scope "/", ChatterWeb do
    pipe_through :browser
    pipe_through :authenticate

    get "/", PageController, :index
  end

  scope "/oidc", ChatterWeb do
    pipe_through :browser

    get "/login", OIDCController, :login
    get "/callback", OIDCController, :callback
    get "/clear", OIDCController, :clear
  end

  scope "/" do
    pipe_through :browser

    live_dashboard "/status", metrics: ChatterWeb.Telemetry
  end
end
