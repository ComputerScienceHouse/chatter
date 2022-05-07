defmodule ChatterWeb.SpaceChannel do
  use ChatterWeb, :channel
  alias ChatterWeb.Presence
  alias ChatterWeb.State.Chats
  alias ChatterWeb.State.Spaces

  def join("space:" <> space_id, %{"user_id" => user_id}, socket) do
    socket =
      socket
      |> assign(:space_id, space_id)
      |> assign(:user_id, user_id)

    send(self(), :after_join)

    {:ok,
     %{
       channel: "space:#{space_id}",
       chats:
         for({msg, user_id} <- Chats.get_channel(space_id), do: %{msg: msg, user_id: user_id}),
       spaces: Spaces.get_all_space_names()
     }, socket}
  end

  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_info(:after_join, socket) do
    push(socket, "presence_state", Presence.list(socket))

    {:ok, _} =
      Presence.track(socket, "user:#{socket.assigns[:user_id]}", %{
        user_id: socket.assigns[:user_id]
      })

    {:noreply, socket}
  end

  def handle_in("msg:post", %{"msg" => msg}, socket) do
    space_id = socket.assigns[:space_id]
    user_id = socket.assigns[:user_id]

    unless space_id == nil or user_id == nil do
      Chats.add(msg, user_id, space_id)
      broadcast!(socket, "msg:new", %{msg: msg, user_id: user_id})
      {:noreply, socket}
    else
      {:error, %{reason: "invalid payload"}}
    end
  end

  def handle_in("msg:get_all", _params, socket) do
    {:reply,
     {:ok,
      for(
        {msg, user_id} <- Chats.get_channel(socket.assigns[:space_id]),
        do: %{msg: msg, user_id: user_id}
      )}, socket}
  end

  def handle_in("space:post", %{"name" => space_name, "user_id" => user_id}, socket) do
    Spaces.create_space(space_name, user_id)
    broadcast!(socket, "space:new", %{name: space_name, user_id: user_id})
    {:noreply, socket}
  end
end
