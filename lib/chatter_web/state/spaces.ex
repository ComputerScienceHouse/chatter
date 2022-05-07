defmodule ChatterWeb.State.Spaces do
  @bucket_key "spaces"
  use ChatterWeb, :stateful_genserver

  alias Chatter.Space
  alias Chatter.Topic
  alias Chatter.DirectPoint

  def start_link(_state) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(spaces) do
    if ChatterWeb.State.Bucket.get(@bucket_key) == nil do
      ChatterWeb.State.Bucket.put(@bucket_key, spaces)
      {:ok, spaces}
    else
      {:ok, ChatterWeb.State.Bucket.get(@bucket_key)}
    end
  end

  def handle_cast({:create_space, space_name, user_id}, spaces) do
    case Map.get(spaces, space_name) do
      nil ->
        no_reply(
          Map.put(spaces, space_name, %Space{
            owner: user_id,
            connection_cap: 100,
            topics: [],
          })
        )

      # no change
      _ ->
        no_reply(spaces)
    end
  end

  def handle_cast({:delete_space, space_name, user_id}, spaces) do
    space = Map.get(spaces, space_name)

    if space != nil and space.owner == user_id do
      no_reply(Map.delete(spaces, space_name))
    else
      no_reply(spaces)
    end
  end

  def handle_cast({:create_topic, space_name, topic_name, notes, user_id}, spaces) do
    if Map.get(spaces, space_name) != nil and
         topic_name not in get_topic_names(spaces, space_name) do
      %Topic{
        owner: user_id,
        name: topic_name,
        notes: notes,
        direct_points: []
      }
      |> append_topic(spaces, space_name)
      |> no_reply
    else
      # no change
      no_reply(spaces)
    end
  end

  def handle_cast({:create_dp_to_topic, space_name, notes, user_id}, spaces) do
    [active_topic | rest] = get_topics(spaces, space_name)

    updated_direct_points =
      Enum.concat(active_topic.direct_points, [
        %DirectPoint{
          owner: user_id,
          notes: notes,
          direct_points: []
        }
      ])

    [%Topic{active_topic | direct_points: updated_direct_points} | rest]
    |> set_topics(spaces, space_name)
    |> no_reply
  end

  def handle_cast({:create_dp_to_id, dp_id, user_id}, spaces) do
    nil
  end

  def handle_call({:next_topic, space_name}, _from, spaces) do
    with [_ | topics] <- get_topics(spaces, space_name) do
      case topics do
        [] ->
          reply(nil, spaces)

        [next_topic] ->
          reply(next_topic, set_topics([next_topic], spaces, space_name))

        [next_topic | rest] ->
          reply(next_topic, set_topics([next_topic | rest], spaces, space_name))
      end
    else
      _ -> reply(nil, spaces)
    end
  end

  def handle_call({:view, space_name}, _from, spaces),
    do: reply(Map.get(spaces, space_name), spaces)

  def handle_call(:get_all_space_names, _from, spaces),
    do: spaces |> Map.keys |> reply(spaces)

  ## debug

  # TODO: remove for v1?
  def handle_cast(:die, _state), do: raise("rec'd :die")

  ## helpers & "delegation"

  def delete_space(space_name, user_id),
    do: GenServer.cast(__MODULE__, {:delete_space, space_name, user_id})

  def create_space(space_name, user_id),
    do: GenServer.cast(__MODULE__, {:create_space, space_name, user_id})

  def create_topic(space_name, topic_name, notes, user_id),
    do: GenServer.cast(__MODULE__, {:create_topic, space_name, topic_name, notes, user_id})

  def get_space(space_name), do: GenServer.call(__MODULE__, {:view, space_name})

  def next_topic(space_name), do: GenServer.call(__MODULE__, {:next_topic, space_name})

  def get_all_space_names, do: GenServer.call(__MODULE__, :get_all_space_names)

  ## util

  defp get_topics(spaces, space_name), do: Map.get(spaces, space_name).topics

  defp get_topic_names(spaces, space_name),
    do: get_topics(spaces, space_name) |> Enum.map(fn topic -> topic.name end)

  defp set_topics(topics, spaces, space_name),
    do: %{spaces | space_name => %Space{Map.get(spaces, space_name) | topics: topics}}

  defp get_active_topic(spaces, space_name) do
    with [active | _] <- get_topics(spaces, space_name) do
      active
    else
      _ -> nil
    end
  end

  defp append_topic(%Topic{} = topic, spaces, space_name),
    do: set_topics(Enum.concat(get_topics(spaces, space_name), [topic]), spaces, space_name)

  defp get_direct_points(spaces, space_name),
    do: Map.get(spaces, space_name).direct_points

  defp get_rest([_, rest]), do: rest
end
