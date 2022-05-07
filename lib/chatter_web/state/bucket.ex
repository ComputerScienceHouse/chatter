defmodule ChatterWeb.State.Bucket do
  use Agent

  # 200 ms. If two restarts are reported within this timeframe of each other,
  # the state bucket should revert to the previous state to prevent against
  # a crash-restart loop caused by polluted bucket state
  @revert_threshold 200

  def start_link(_state) do
    Agent.start_link(fn -> %{prev: %{}, cur: %{}, last_reporeted_restart: nil} end,
      name: __MODULE__
    )
  end

  def get(key) do
    Agent.get(__MODULE__, &(Map.get(&1, :cur) |> Map.get(key)))
  end

  def put(key, value) do
    Agent.update(__MODULE__, &Map.put(&1, :prev, Map.get(&1, :cur)))
    Agent.update(__MODULE__, &Map.put(&1, :cur, Map.put(Map.get(&1, :cur), key, value)))
  end

  @doc """
  called by the ChatterWeb.State.Supervisor whenever a state-child is restarted
  """
  def report_restart do
    last_fail = Agent.get(__MODULE__, :last_reported_restart)
    cur_fail = :os.system_time(:millisecond)

    Agent.put(__MODULE__, &Map.put(&1, :last_fail, cur_fail))

    unless is_nil(last_fail) or cur_fail - last_fail < @revert_threshold, do: revert()
  end

  def revert do
    Agent.update(__MODULE__, &Map.put(&1, :cur, Map.get(&1, :prev)))
  end

  def get_all, do: Agent.get(__MODULE__, & &1)
end
