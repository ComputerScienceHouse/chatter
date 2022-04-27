defmodule Chatter.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ChatterWeb.Telemetry,
      {Phoenix.PubSub, name: Chatter.PubSub},
      ChatterWeb.Presence,
      ChatterWeb.Endpoint,
    ]

    opts = [strategy: :one_for_one, name: Chatter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # rebuild on changes
  @impl true
  def config_change(changed, _new, removed) do
    ChatterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
