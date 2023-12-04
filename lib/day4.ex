defmodule Aoc.Day4 do
  @moduledoc """
  Solutions for Day 4.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 4

  @impl Day
  def a(cards) do
    cards
    |> Enum.map(&winning_score/1)
    |> Enum.sum()
  end

  @impl Day
  def b(cards) do
    1..map_size(cards)
    |> Enum.reduce(cards, &scan/2)
    |> Map.values()
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_line/1)
      |> Enum.into(%{})
    end
  end

  def parse_line("Card" <> <<number::binary-size(4)>> <> ":" <> numbers) do
    [winners, numbers] =
      numbers
      |> String.split("|", trim: true)
      |> Enum.map(fn x ->
        x
        |> String.split(" ", trim: true)
        |> MapSet.new()
      end)

    {String.to_integer(String.trim(number)), {winning_count(winners, numbers), 1}}
  end

  defp winning_score({_, {matches, _}}) do
    matches
    |> Kernel.-(1)
    |> then(&Kernel.**(2, &1))
    |> trunc()
  end

  defp winning_count(winners, numbers) do
    winners
    |> MapSet.intersection(numbers)
    |> Enum.count()
  end

  defp scan(index, cards) do
    {matches, copies} = Map.get(cards, index)

    with true <- matches > 0,
         range <- (index + 1)..(index + 1 + (matches - 1)) do
      Enum.reduce(range, cards, fn i, cards ->
        Map.update!(cards, i, fn {card_matches, card_copies} ->
          {card_matches, card_copies + copies}
        end)
      end)
    else
      _ -> cards
    end
  end
end
