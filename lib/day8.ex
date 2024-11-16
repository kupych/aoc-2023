defmodule Aoc.Day8 do
  @moduledoc """
  Solutions for Day 8.
  """
  @behaviour Aoc.Day

  alias Aoc.{Day, Utilities}

  @impl Day
  def day(), do: 8

  @impl Day
  def a(input) do
    input
    |> run()
    |> Map.get(:count)
  end

  @impl Day
  def b(input) do
    input
    |> run_ghosts()
    |> Map.get(:ghosts)
    |> Utilities.lcm()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> do_parse_input()
    end
  end

  def do_parse_input([steps | nodes]) do
    steps =
      steps
      |> String.graphemes()
      |> Enum.map(fn
        "L" -> 0
        "R" -> 1
      end)

    %{
      steps: Stream.cycle(steps),
      nodes: parse_nodes(nodes)
    }
  end

  defp parse_nodes(nodes, acc \\ %{})

  defp parse_nodes([], acc) do
    acc
  end

  defp parse_nodes([node | nodes], acc) when byte_size(node) > 0 do
    [node, left, right] = String.split(node, ~r/\W+/, trim: true)
    parse_nodes(nodes, Map.put(acc, node, {left, right}))
  end

  defp parse_nodes([_ | nodes], acc) do
    parse_nodes(nodes, acc)
  end

  defp run(%{nodes: nodes, steps: steps}, start \\ "AAA", goal \\ "ZZZ") do
    Enum.reduce_while(steps, %{current: start, goal: goal, count: 0, nodes: nodes}, &do_run/2)
  end

  defp do_run(_, %{current: current, goal: current} = acc) do
    {:halt, acc}
  end

  defp do_run(dir, %{current: current, count: count, nodes: nodes} = acc) do
    next = elem(nodes[current], dir)
    {:cont, %{acc | current: next, count: count + 1}}
  end

  defp run_ghosts(%{nodes: nodes, steps: steps}) do
    ghosts =
      nodes
      |> Map.keys()
      |> Enum.filter(&ghost_start_node?/1)

    Enum.reduce_while(steps, %{ghosts: ghosts, count: 0, nodes: nodes}, &do_run_ghosts/2)
  end

  defp do_run_ghosts(dir, %{ghosts: ghosts, count: count, nodes: nodes} = acc) do
    if Enum.all?(ghosts, &is_integer/1) do
      {:halt, acc}
    else
      ghosts =
        ghosts
        |> Enum.map(fn
          x when is_integer(x) ->
            x

          x ->
            next = elem(nodes[x], dir)

            if ghost_goal_node?(next) do
              count + 1
            else
              next
            end
        end)

      {:cont, %{acc | ghosts: ghosts, count: count + 1}}
    end
  end

  defp ghost_goal_node?(<<_::binary-size(2)>> <> "Z"), do: true
  defp ghost_goal_node?(_), do: false

  defp ghost_start_node?(<<_::binary-size(2)>> <> "A"), do: true
  defp ghost_start_node?(_), do: false
end
