defmodule ChatterWeb.State.Chats do
  use GenServer

  def start_link(_state) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(msgs) do
    {:ok, msgs}
  end

  def handle_cast({:add, msg, user_id, channel}, msgs) do
    {:noreply, Map.put(msgs, channel, [{msg, user_id} | Map.get(msgs, channel) || []])}
  end

  def handle_cast({:clear, channel}, msgs) do
    {:noreply, Map.put(msgs, channel, nil)}
  end

  def handle_call(:view, _from, msgs) do
    {:reply, msgs, msgs}
  end

  ## helper functions

  def get_channel(channel) do
    get_all() |> Map.get(channel) || []
  end

  def add(msg, user_id, channel) do
    GenServer.cast(__MODULE__, {:add, msg, user_id, channel})
  end

  def clear_channel(channel) do
    GenServer.cast(__MODULE__, {:clear, channel})
  end

  def get_all do
    GenServer.call(__MODULE__, :view)
  end
end
