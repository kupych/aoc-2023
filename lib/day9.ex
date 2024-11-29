defmodule Aoc.Day9 do
  @moduledoc """
  Solutions for Day 9.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 9

  @impl Day
  def a(input) do
    input
    |> Enum.map(&get_extrapolated/1)
    |> Enum.sum()
  end

  @impl Day
  def b(input) do
    input
    |> Enum.map(&get_prextrapolated/1)
    |> Enum.sum()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_history/1)
    end
  end

  def parse_history(history) do
    history
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> then(&[&1])
    |> integration()
  end

  defp integration([[0] | _] = acc), do: acc

  defp integration([history | _] = acc) do
    if Enum.all?(history, &(&1 == 0)) do
      acc
    else
      new_history =
        history
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.map(fn [a, b] -> b - a end)

      integration([new_history | acc])
    end
  end

  defp extrapolate([], extr), do: extr
  defp extrapolate([a | rest], [b | _] = acc), do: extrapolate(rest, [a + b | acc])

  defp prextrapolate([], prextr), do: prextr
  defp prextrapolate([a | rest], [b | _] = acc), do: prextrapolate(rest, [a - b | acc])

  defp get_extrapolated(history) do
    history
    |> Enum.map(&Enum.reverse/1)
    |> Enum.map(&hd/1)
    |> tl()
    |> extrapolate([0])
    |> hd()
  end

  defp get_prextrapolated(history) do
    history
    |> Enum.map(&hd/1)
    |> tl()
    |> prextrapolate([0])
    |> hd()
  end
end
