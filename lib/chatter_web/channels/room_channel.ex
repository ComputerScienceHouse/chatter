defmodule ChatterWeb.RoomChannel do
  use ChatterWeb, :channel
  alias ChatterWeb.Presence

  def join("room:" <> room_id, %{"user_id" => user_id}, socket) do
    socket = socket
      |> assign(:room_id, room_id)
      |> assign(:user_id, user_id)

    send(self(), :after_join)
    {:ok, %{channel: "room:#{room_id}"}, socket}
  end

  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)

    {:ok, _} = Presence.track(socket, "user:#{socket.assigns[:user_id]}", %{
      user_id: socket.assigns[:user_id],
      username: socket.assigns[:user_id]
    })

    {:noreply, socket}
  end

  def handle_in("req_announce", payload, socket) do
    broadcast(socket, "announce", payload)
    {:noreply, socket}
  end
end
