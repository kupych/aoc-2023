defmodule Aoc.Day6 do
  @moduledoc """
  Solutions for Day 6.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 6

  @impl Day
  def a(races) do
    races
    |> Enum.map(&process_line/1)
    |> Enum.zip()
    |> Enum.map(&process_race/1)
    |> Enum.map(&Enum.count/1)
    |> Enum.product()
  end

  @impl Day
  def b(race) do
    race
    |> Enum.map(&process_line_b/1)
    |> Enum.zip()
    |> hd()
    |> process_race()
    |> Enum.count()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
    end
  end

  def process_race({time, distance}) do
    1..time
    Enum.filter(1..time, &will_beat_record?(&1, time, distance))
  end

  def will_beat_record?(speed, record, distance) do
    (speed * (record - speed)) >= distance
  end

  defp process_line(line) do
    line
    |> String.split(~r/\s+/, trim: true)
    |> tl()
    |> Enum.map(&String.to_integer/1)
  end

  defp process_line_b(line) do
    line
    |> String.replace(~r/\s+/, "")
    |> String.split(":", trim: true)
    |> tl()
    |> Enum.map(&String.to_integer/1)
  end
end
