defmodule Darts do
  @type position :: {number, number}

  @doc """
  Calculate the score of a single dart hitting a target
  """
  @spec score(position :: position) :: integer
  def score({x, y}) do
    case :math.sqrt(x * x + y * y) do
      r when r > 10 -> 0
      r when r > 5 -> 1
      r when r > 1 -> 5
      _ -> 10
    end
  end
end
