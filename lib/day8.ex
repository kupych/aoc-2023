defmodule Aoc.Day8 do
  @moduledoc """
  Solutions for Day 8.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 8

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
