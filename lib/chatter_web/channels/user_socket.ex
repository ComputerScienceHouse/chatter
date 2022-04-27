defmodule ChatterWeb.UserSocket do
  use Phoenix.Socket

  channel "room:*", ChatterWeb.RoomChannel

  @impl true
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  # Returning `nil` makes this socket anonymous.
  @impl true
  def id(_socket), do: nil
end
