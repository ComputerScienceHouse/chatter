defmodule ChatterWeb.Plugs.AssignGitRev do
  use ChatterWeb, :plug

  def init(default), do: default

  def call(conn, _default) do
    {git_rev, 0} = System.cmd("git", ["rev-parse", "--short", "HEAD"])
    assign(conn, :git_rev, git_rev |> String.trim("\n"))
  end
end