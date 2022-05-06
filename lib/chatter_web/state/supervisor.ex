defmodule ChatterWeb.State.Supervisor do
  use Supervisor

  def start_link(_state) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_state) do
    children = [
      ChatterWeb.State.Chats,
      ChatterWeb.State.Spaces,
      ChatterWeb.State.Num
    ]

    # http://aka.erwijet.com/one-for-all
    Supervisor.init(children, strategy: :one_for_all)
  end
end
