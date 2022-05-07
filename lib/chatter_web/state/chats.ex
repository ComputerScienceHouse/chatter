defmodule ChatterWeb.State.Chats do
  @bucket_key "chats"
  use ChatterWeb, :stateful_genserver

  def start_link(_state) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(msgs) do
    if ChatterWeb.State.Bucket.get(@bucket_key) == nil do
      ChatterWeb.State.Bucket.put(@bucket_key, msgs)
      {:ok, msgs}
    else
      {:ok, ChatterWeb.State.Bucket.get(@bucket_key)}
    end
  end

  def handle_cast({:add, msg, user_id, channel}, msgs) do
    Map.put(msgs, channel, [{msg, user_id} | Map.get(msgs, channel) || []]) |> no_reply
  end

  def handle_cast({:clear, channel}, msgs) do
    Map.put(msgs, channel, nil) |> no_reply
  end

  def handle_call(:view, _from, msgs) do
    reply(msgs, msgs)
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
