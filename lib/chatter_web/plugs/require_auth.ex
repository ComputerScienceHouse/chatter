defmodule ChatterWeb.Plugs.RequireAuth do
  use ChatterWeb, :plug

  def init(default), do: default

  def call(conn, _default) do
    case get_session(conn, :usr) do
      nil -> redirect(conn, to: "/oidc/login")
      usr -> assign(conn, :user, usr)
    end
  end
end
