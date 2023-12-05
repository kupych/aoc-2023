defmodule Aoc.Day5 do
  @moduledoc """
  Solutions for Day 5.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 5

  @impl Day
  def a(lines) do
    {mapped, to_map, _} = Enum.reduce(lines, nil, &process_line/2)

    mapped
    |> Kernel.++(to_map)
    |> Enum.min()
  end

  @impl Day
  def b(["seeds: " <> seeds | lines]) do
    seeds =
      seeds
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> Enum.map(fn [start, length] -> {start, start + length - 1} end)
      |> IO.inspect()

    {mapped, to_map, _} = Enum.reduce(lines, {seeds, [], "seed"}, &process_line_b/2)

    mapped
    |> Kernel.++(to_map)
    |> IO.inspect()

    :not_solved
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      String.split(file, "\n", trim: true)
    end
  end

  def process_line("seeds: " <> line, _) do
    line
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> then(&{&1, [], "soil"})
  end

  def process_line(line, {to_map, mapped, active} = acc) do
    case Regex.run(~r/^\w+\-to\-(\w+)/, line) do
      [_, new_active] ->
        {to_map ++ mapped, [], new_active}

      nil ->
        do_map(line, acc)
    end
  end

  def process_line_b(line, {to_map, mapped, active} = acc) do
    case Regex.run(~r/^\w+\-to\-(\w+)/, line) do
      [_, new_active] ->
        {to_map ++ mapped, [], new_active}

      nil ->
        {matches, no_matches} = do_map_ranges(line, acc)
        {no_matches, mapped ++ matches, active} |> IO.inspect()
    end
  end

  defp do_map(line, {to_map, mapped, active} = acc) do
    [dest, source, length] =
      line
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)

    {matches, no_matches} =
      Enum.split_with(to_map, &in_range?(&1, source, source + (length - 1)))

    matches
    |> Enum.map(&Kernel.+(&1, dest - source))
    |> then(&{no_matches, mapped ++ &1, active})
  end

  defp do_map_ranges(line, {to_map, mapped, active} = acc) do
    [dest, source, length] =
      line
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)

    {matches, no_matches} = maybe_split_and_process_ranges(to_map, {[], []}, source, length, dest)
  end

  defp maybe_split_and_process_ranges([], {matches, no_matches}, _, _, _),
    do: {matches, no_matches}

  defp maybe_split_and_process_ranges([range | rest], {matches, no_matches}, source, length, dest) do
    {match, no_match} = get_overlap(range, source, source + (length - 1), dest - source)

    maybe_split_and_process_ranges(
      rest,
      {matches ++ match, no_matches ++ no_match},
      source,
      length,
      dest
    )
  end

  defp in_range?(x, min, max) when x >= min and x <= max, do: true

  defp in_range?(_, _, _), do: false

  defp get_overlap({min, max}, start, end_range, diff) do
    cond do
      min >= start and max <= end_range ->
        {[{min + diff, max + diff}], []}

      max <= end_range ->
        {[{start + diff, max + diff}], [{min, start - 1}]}

      min >= start ->
        {[{min + diff, end_range + diff}], [{end_range + 1, max}]}

      true ->
        {[], [{min, max}]}
    end
  end
end
