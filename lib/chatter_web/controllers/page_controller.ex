defmodule ChatterWeb.PageController do
  use ChatterWeb, :controller
  alias ChatterWeb.Presence

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
