defmodule ChatterWeb.State.Num do
  use GenServer

  def start_link(_state), do: GenServer.start_link(__MODULE__, 0, name: __MODULE__)

  def init(n), do: {:ok, n}

  def handle_call(:next, _from, n), do: {:reply, n, n + 1}

  def next, do: GenServer.call(__MODULE__, :next)
end
