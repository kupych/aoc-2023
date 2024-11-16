defmodule Aoc.Utilities do
  @moduledoc """
  Generic utilities for Advent of Code puzzles.
  """

  @doc """
  `transpose/1` transposes a 2d-array, i.e. 
  converts rows to columns and vice versa.
  """
  def transpose(matrix) do
    matrix
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  @doc """
  `binary_to_digits/1` takes a string of 
  numbers and converts it to a tuple of
  integers representing the digits.
  """
  def binary_to_digits(string) do
    string
    |> binary_to_digit_enum()
    |> List.to_tuple()
  end

  def binary_to_digit_enum(string) do
    string
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  `get_adjacent/2` takes a coordinate formatted like {x, y}
  and returns a list of all adjacent coordinates. If the optional
  `diagonal` parameter is set to `true`, diagonal coordinates
  are included as well
  """
  def get_adjacent(coords, diagonal \\ false)

  def get_adjacent({x, y}, :diagonal) do
    [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1}
    ]
  end

  def get_adjacent({x, y}, _) do
    [{x, y - 1}, {x - 1, y}, {x + 1, y}, {x, y + 1}]
  end

  @doc """
  Calculates the greatest common divisor (GCD) of a list of integers.
  """
  def gcd([number | numbers]) do
    Enum.reduce(numbers, number, &do_gcd/2)
  end

  defp do_gcd(a, 0), do: a
  defp do_gcd(a, b), do: do_gcd(b, rem(a, b))

  @doc """
  Calculates the least common multiple (LCM) of a list of integers.
  """
  def lcm([number | numbers]) do
    Enum.reduce(numbers, number, &do_lcm/2)
  end

  defp do_lcm(a, b), do: trunc(a * b / do_gcd(a, b))
end
