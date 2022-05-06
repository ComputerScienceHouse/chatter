defmodule ChatterWeb.OIDCController do
  use ChatterWeb, :controller
  alias Chatter.UserController
  alias Chatter.UserInfo

  @moduledoc """
  Manage CSH OIDC related routes
  """

  def login(conn, _) do
    redirect(conn, external: Keycloak.authorize_url!())
  end

  def callback(conn, %{"code" => code}) do
    {:ok, %{"preferred_username" => p_username, "given_name" => g_name, "family_name" => f_name}} =
      Keycloak.get_token!(code: code).token.access_token |> Joken.peek_claims()

    usr = %UserInfo{
      preferred_username: p_username,
      given_name: g_name,
      family_name: f_name,
      # TODO: replace with list of RTP's
      is_admin?: p_username == "holewinski"
    }

    conn
    |> put_session(:usr, usr)
    |> redirect(to: "/")
  end

  def clear(conn, _) do
    conn
    |> put_session(:usr, nil)
    |> redirect(to: "/")
  end
end
