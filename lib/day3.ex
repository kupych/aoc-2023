defmodule Aoc.Day3 do
  @moduledoc """
  Solutions for Day 3.
  """
  @behaviour Aoc.Day

  alias Aoc.Day
  alias Aoc.Utilities

  @initial %{grid: %{}, numbers: [], symbols: %{}}

  defguard is_digit?(char) when char in ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

  @impl Day
  def day(), do: 3

  @impl Day
  def a(schematic) do
    schematic
    |> Map.get(:numbers)
    |> Map.values()
    |> Enum.filter(& &1.is_part?)
    |> Enum.map(&String.to_integer(&1.value))
    |> Enum.sum()
  end

  @impl Day
  def b(schematic) do
    schematic
    |> Map.get(:numbers)
    |> Map.values()
    |> Enum.reject(&is_nil(&1.gear))
    |> Enum.group_by(& &1.gear)
    |> Enum.map(fn
      {_, [a, b]} -> String.to_integer(a.value) * String.to_integer(b.value)
      {_, _} -> 0
    end)
    |> Enum.sum()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.codepoints/1)
      |> parse_schematic(@initial)
    end
  end

  def parse_schematic([], acc), do: acc

  def parse_schematic(grid, acc) do
    acc =
      acc
      |> Map.put(:grid, parse_grid(grid))
      |> get_symbols()
      |> get_numbers()
  end

  defp parse_grid(grid) do
    max_y = Enum.count(grid) - 1
    max_x = Enum.count(Enum.at(grid, 0)) - 1

    grid =
      grid
      |> Enum.with_index()
      |> Enum.map(fn {row, y} ->
        row
        |> Enum.with_index()
        |> Enum.map(fn {char, x} ->
          {{x, y}, char}
        end)
      end)
      |> List.flatten()
      |> Enum.into(%{})
      |> Map.put(:max_x, max_x)
      |> Map.put(:max_y, max_y)
  end

  defp get_symbols(%{grid: grid} = acc) do
    grid
    |> Enum.filter(fn {_, char} -> is_symbol?(char) end)
    |> Enum.into(%{})
    |> then(&Map.put(acc, :symbols, &1))
  end

  defp get_numbers(%{grid: grid} = acc) do
    coords =
      for y <- 0..grid.max_y, x <- 0..grid.max_x do
        {x, y}
      end

    coords
    |> find_numbers(acc, nil, [], [])
    |> Enum.into(%{})
    |> then(&Map.put(acc, :numbers, &1))
  end

  defp find_numbers([], _acc, _start, _active_digits, numbers), do: numbers

  defp find_numbers([{x, y} | coords], %{grid: grid} = acc, start, active_digits, numbers) do
    char = Map.get(grid, {x, y})

    cond do
      is_digit?(char) ->
        find_numbers(coords, acc, start || {x, y}, active_digits ++ [char], numbers)

      is_tuple(start) ->
        number = Enum.join(active_digits, "")

        record =
          {start,
           %{
             gear: check_gear(start, number, acc.symbols),
             is_part?: check_part(start, number, acc.symbols),
             value: Enum.join(active_digits, "")
           }}

        find_numbers(coords, acc, nil, [], [record | numbers])

      true ->
        find_numbers(coords, acc, start, active_digits, numbers)
    end
  end

  defp is_symbol?("."), do: false
  defp is_symbol?(char) when is_digit?(char), do: false
  defp is_symbol?(_), do: true

  defp check_part({x, y}, number, symbols) do
    digits =
      for add <- 0..(String.length(number) - 1) do
        {x + add, y}
      end

    digits
    |> Enum.flat_map(&Utilities.get_adjacent(&1, :diagonal))
    |> Enum.uniq()
    |> Enum.any?(&Map.has_key?(symbols, &1))
  end

  defp check_gear({x, y}, number, symbols) do
    digits =
      for add <- 0..(String.length(number) - 1) do
        {x + add, y}
      end

    digits
    |> Enum.flat_map(&Utilities.get_adjacent(&1, :diagonal))
    |> Enum.uniq()
    |> Enum.find(&(Map.get(symbols, &1) == "*"))
  end
end
