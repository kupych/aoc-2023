defmodule Aoc.Day2 do
  @moduledoc """
  Solutions for Day 2.
  """
  @behaviour Aoc.Day

  alias Aoc.Day

  @impl Day
  def day(), do: 2

  @impl Day
  def a(games) do
    games
    |> Enum.filter(&valid_game?(&1, %{blue: 14, green: 13, red: 12}))
    |> Enum.map(& &1.number)
    |> Enum.sum()
  end

  @impl Day
  def b(games) do
    games
    |> Enum.map(&(&1.blue * &1.green * &1.red))
    |> Enum.sum()
  end

  @impl Day
  def parse_input() do
    with {:ok, file} <- Day.load(__MODULE__) do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_game/1)
    end
  end

  defp parse_game(line) do
    [text, number, instructions] = Regex.run(~r/Game (\d+): (.+)/, line)

    %{
      blue: 0,
      green: 0,
      red: 0,
      text: text,
      number: String.to_integer(number),
      instructions: String.split(instructions, "; ", trim: true)
    }
    |> run_game()
  end

  defp run_game(%{instructions: instructions} = game) do
    Enum.reduce(instructions, game, &do_run_game/2)
  end

  defp do_run_game(round, game) do
    round
    |> String.split(", ", trim: true)
    |> Enum.reduce(game, &do_run_instruction/2)
  end

  defp do_run_instruction(instruction, game) do
    [number, color] = String.split(instruction, " ", trim: true)
    number = String.to_integer(number)
    color = String.to_existing_atom(color)
    Map.update!(game, color, &max(&1, number))
  end

  defp valid_game?(%{blue: blue, green: green, red: red}, %{
         blue: blue_max,
         green: green_max,
         red: red_max
       }) do
    blue <= blue_max and green <= green_max and red <= red_max
  end
end
