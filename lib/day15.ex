defmodule Aoc.Day15 do
  @moduledoc """
  Solutions for Day 15.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 15

  @impl Day
  def a(_) do
    :not_solved
  end

  @impl Day
  def b(_) do
    :not_solved
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
    end
  end
end
