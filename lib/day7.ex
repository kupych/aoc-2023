defmodule Aoc.Day7 do
  @moduledoc """
  Solutions for Day 7.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @hands %{
    high_card: 1,
    one_pair: 2,
    two_pairs: 3,
    three_of_a_kind: 4,
    full_house: 5,
    four_of_a_kind: 6,
    five_of_a_kind: 7
  }

  @impl Day
  def day(), do: 7

  @impl Day
  def a(hands) do
    hands
    |> Enum.map(&parse_hand/1)
    |> Enum.sort_by(&{@hands[&1.type], &1.numeric_score})
    |> Enum.with_index()
    |> Enum.map(fn {%{bid: bid}, index} -> bid * (index + 1) end)
    |> Enum.sum()
  end

  @impl Day
  def b(hands) do
    hands
    |> Enum.map(&String.replace(&1, "J", "O"))
    |> Enum.map(&parse_hand/1)
    |> Enum.sort_by(&{@hands[&1.type], &1.numeric_score})
    |> Enum.with_index()
    |> Enum.map(fn {%{bid: bid}, index} -> bid * (index + 1) end)
    |> Enum.sum()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      String.split(file, "\n", trim: true)
    end
  end

  defp parse_hand(<<hand::binary-size(5)>> <> " " <> bid) do
    cards = String.graphemes(hand)

    %{
      bid: String.to_integer(bid),
      hand: hand,
      numeric_score: calculate_score(cards),
      type: get_hand_type(cards)
    }
  end

  defp calculate_score(cards) do
    cards
    |> Enum.map(&get_card_hex/1)
    |> Enum.join()
    |> String.to_integer(16)
  end

  defp get_card_hex("T"), do: "A"
  defp get_card_hex("J"), do: "B"
  defp get_card_hex("Q"), do: "C"
  defp get_card_hex("K"), do: "D"
  defp get_card_hex("A"), do: "E"
  defp get_card_hex("O"), do: "1"
  defp get_card_hex(card), do: card

  defp get_hand_type(cards) do
    cards
    |> Enum.frequencies()
    |> parse_jokers()
    |> Enum.sort_by(&elem(&1, 1), :desc)
    |> do_get_type()
  end

  defp do_get_type([{_, 5}]), do: :five_of_a_kind
  defp do_get_type([{_, 4} | _]), do: :four_of_a_kind
  defp do_get_type([{_, 3}, {_, 2}]), do: :full_house
  defp do_get_type([{_, 3} | _]), do: :three_of_a_kind
  defp do_get_type([{_, 2}, {_, 2} | _]), do: :two_pairs
  defp do_get_type([{_, 2} | _]), do: :one_pair
  defp do_get_type(_), do: :high_card

  defp parse_jokers(%{"O" => _} = cards) when map_size(cards) > 1 do
    {jokers, cards} = Map.pop(cards, "O")
    [{highest, count} | cards] = Enum.sort_by(cards, &elem(&1, 1), :desc)
    [{highest, count + jokers} | cards]
  end

  defp parse_jokers(cards), do: cards
end
