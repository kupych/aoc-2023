defmodule Aoc.Day10 do
  @moduledoc """
  Solutions for Day 10.
  """
  @behaviour Aoc.Day

  alias Aoc.Day
  alias IO.ANSI

  @entrances %{
    "-" => [{-1, 0}, {1, 0}],
    "7" => [{-1, 0}, {0, 1}],
    "F" => [{1, 0}, {0, 1}],
    "J" => [{-1, 0}, {0, -1}],
    "L" => [{1, 0}, {0, -1}],
    "|" => [{0, -1}, {0, 1}],
    "." => []
  }

  @clock %{
    {-1, 0} => :left,
    {0, -1} => :up,
    {0, 1} => :down,
    {1, 0} => :right
  }

  @spaces %{
    "-" => [[{0, -1}], [{0, 1}]],
    "7" => [[{-1, 0}, {0, 1}], []],
    "F" => [[{-1, 0}, {0, -1}], []],
    "J" => [[{1, 0}, {0, 1}], []], 
    "L" => [[{-1, 0}, {0, 1}], []],
    "|" => [[{-1, 0}], [{1, 0}]]
  }

  @pipes %{
    "-" => "━",
    "7" => "┓",
    "F" => "┏",
    "L" => "┗",
    "J" => "┛",
    "|" => "┃",
    "." => " ",
    "S" => "S"
  }

  @dirs %{}

  @impl Day
  def day(), do: 10

  @impl Day
  def a(%{start: start} = input) do
    input
    |> run_through_pipes()
    |> Map.get(:count)
    |> Kernel.div(2)
  end

  @impl Day
  def b(%{start: start} = input) do
    :not_solved
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.map(&Enum.with_index/1)
      |> Enum.with_index()
      |> parse_pipes()
    end
  end

  def parse_pipes(map) do
    for {y, y_i} <- map, {v, x_i} <- y do
      do_parse_pipe(v, y_i, x_i)
    end
    |> Enum.into(%{})
  end

  defp do_parse_pipe("S", y, x) do
    {:start, {x, y}}
  end

  defp do_parse_pipe(".", y, x) do
    {{x, y}, %{coords: {x, y}, char: ".", distance: nil, entrances: [], inside?: nil}}
  end

  defp do_parse_pipe(pipe, y, x) do
    @entrances[pipe]
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
    |> then(&{{x, y}, %{coords: {x, y}, dir: @dirs[pipe], char: @pipes[pipe], distance: nil, entrances: &1}})
  end

  defp run({prev, curr}, %{count: count, start: start} = pipes) do
    current_pipe = Map.get(pipes, curr)

    if curr == start do
      Map.put(pipes, :count, count)
    else
      [next] = current_pipe.entrances |> Enum.reject(&(&1 == prev))

      pipes =
        pipes
        |> Map.put(current_pipe, %{current_pipe | distance: count})

      run({curr, next}, %{pipes | count: count + 1})
    end
  end

  def is_inside?({x, y}, map) do
    current = Map.get(map, {x, y})

    inside? =
      @dirs
      |> Enum.map(&check_inside?({x, y}, &1, map))
      |> Enum.all?()

    Map.put(map, {x, y}, %{current | inside?: inside?})
  end

  def check_inside?({x, y}, {dx, dy}, map) do
    case Map.get(map, {x + dx, y + dy}) do
      nil -> false
      %{inside?: true} -> true
      %{inside?: false} -> false
      %{distance: nil} -> check_inside?({x + dx, y + dy}, {dx, dy}, map)
      _ -> true
    end
  end

  defp run_through_pipes(%{start: start} = input) do
    input
    |> Map.values()
    |> Enum.filter(fn
      %{entrances: [^start, _]} -> true
      %{entrances: [_, ^start]} -> true
      _ -> false
    end)
    |> hd()
    |> then(&{start, &1.coords})
    |> run(Map.put(input, :count, 1))
  end

  defp flood_fill(start: input) do
    pipe_steps =
      input
      |> Enum.filter(fn
        {_, %{distance: d}} when is_integer(d) -> true
        _ -> false
      end)
      |> Enum.sort_by(fn {_, %{distance: d}} -> d end)
      |> Enum.map(&elem(&1, 0))
      
  end
end
