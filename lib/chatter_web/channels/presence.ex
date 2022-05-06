defmodule ChatterWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.
  """
  use Phoenix.Presence,
    otp_app: :chatter,
    pubsub_server: Chatter.PubSub
end
