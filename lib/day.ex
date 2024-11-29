defmodule Aoc.Day do
  @moduledoc """
  Generic module for a puzzle day.
  """

  @doc """
  Returns the solution for part A of the problem.
  """
  @callback a(term) :: String.t()

  @doc """
  Returns the solution for part B of the problem.
  """
  @callback b(term) :: String.t()
  @doc """
  Returns the day number.
  """
  @callback day() :: integer

  @doc """
  Parses the file input for the problem.
  """
  @callback parse_input() :: term

  @doc """
  Loads the file input for the problem if available.

  ## Examples
      iex> load(Aoc.Day1)
      {:ok, "......."}
  """
  def load(module), do: File.read("files/#{module.day}")

  @doc """
  Returns the solution for parts A and B of the problem.

  ## Examples
      iex> solve(Aoc.Day1)
      "The solution to 1a is: 12345"
      "The solution to 1b is: 12345"
  """
  def solve() do
    :aoc
    |> :application.get_key(:modules)
    |> elem(1)
    |> IO.inspect()
    |> Enum.filter(&Kernel.function_exported?(&1, :a, 1))
    |> Enum.sort_by(&apply(&1, :day, []))
    |> IO.inspect()
    |> Enum.each(&solve(&1))
  end

  def solve(module) when is_atom(module) do
    data = module.parse_input()
    IO.puts("The solution to #{module.day()}a is: #{module.a(data)}")
    IO.puts("The solution to #{module.day()}b is: #{module.b(data)}")
  end

  def solve(day) when is_integer(day) do
    module = Module.concat(Aoc, "Day#{day}")

    case Kernel.function_exported?(module, :a, 1) do
      true -> solve(module)
      false -> :invalid_day
    end
  end
end
