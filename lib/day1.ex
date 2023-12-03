defmodule Aoc.Day1 do
  @moduledoc """
  Solutions for Day 1.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 1

  @impl Day
  def a(lines) do
    lines
    |> Enum.map(&get_calibration_value/1)
    |> Enum.sum()
  end

  @impl Day
  def b(lines) do
    lines
    |> Enum.map(&get_calibration_value_with_words/1)
    |> Enum.sum()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.trim()
      |> String.split("\n")
    end
  end

  defp get_calibration_value(line) do
    ~r/\d/
    |> Regex.scan(line)
    |> get_first_and_last()
    |> Enum.join("")
    |> String.to_integer()
  end

  defp get_calibration_value_with_words(line) do
    ~r/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/
    |> Regex.scan(line)
    |> Enum.flat_map(&tl/1)
    |> get_first_and_last()
    |> Enum.map(&convert_to_number/1)
    |> Enum.join("")
    |> String.to_integer()
  end

  defp get_first_and_last([digit]) do
    [digit, digit]
  end

  defp get_first_and_last([_ | _] = digits) do
    Enum.take_every(digits, Enum.count(digits) - 1)
  end

  defp convert_to_number("one"), do: "1"
  defp convert_to_number("two"), do: "2"
  defp convert_to_number("three"), do: "3"
  defp convert_to_number("four"), do: "4"
  defp convert_to_number("five"), do: "5"
  defp convert_to_number("six"), do: "6"
  defp convert_to_number("seven"), do: "7"
  defp convert_to_number("eight"), do: "8"
  defp convert_to_number("nine"), do: "9"
  defp convert_to_number(digit), do: digit
end
