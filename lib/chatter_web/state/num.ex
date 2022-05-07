defmodule ChatterWeb.State.Num do
  @bucket_key "num"
  use ChatterWeb, :stateful_genserver

  def start_link(_state), do: GenServer.start_link(__MODULE__, 0, name: __MODULE__)

  def init (num) do
    if ChatterWeb.State.Bucket.get(@bucket_key) == nil do
      ChatterWeb.State.Bucket.put(@bucket_key, num)
      {:ok, num}
    else
      {:ok, ChatterWeb.State.Bucket.get(@bucket_key)}
    end
  end

  def handle_call(:next, _from, n), do: reply(n, n + 1)

  def next, do: GenServer.call(__MODULE__, :next)
end
