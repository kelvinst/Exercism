defmodule Bowling do
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  @spec start() :: any
  def start, do: []

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful error tuple.
  """

  @over "Cannot roll after game is over"

  @spec roll(any, integer) :: {:ok, any} | {:error, String.t()}
  def roll([10, _, _, _, _, _, _, _, _, _] = game, roll), do: do_roll(game, roll)
  def roll([{_, nil}, _, _, _, _, _, _, _, _, _] = g, r), do: do_roll(g, r)
  def roll([{a, b}, _, _, _, _, _, _, _, _, _] = g, r) when a + b == 10, do: do_roll(g, r)
  def roll([{_, x}, 10, _, _, _, _, _, _, _, _, _], _) when x != nil, do: {:error, @over}
  def roll([{_, nil}, {a, b}, _, _, _, _, _, _, _, _, _], _) when a + b == 10, do: {:error, @over}
  def roll([_, _, _, _, _, _, _, _, _, _], _), do: {:error, @over}
  def roll(game, roll), do: do_roll(game, roll)

  @pin_count "Pin count exceeds pins on the lane"

  defp do_roll(_, roll) when roll < 0, do: {:error, "Negative roll is invalid"}
  defp do_roll(_, roll) when roll > 10, do: {:error, @pin_count}
  defp do_roll([{p, nil} | _], r) when p + r > 10, do: {:error, @pin_count}
  defp do_roll([{prev, nil} | game], roll), do: {:ok, [{prev, roll} | game]}
  defp do_roll(game, 10), do: {:ok, [10 | game]}
  defp do_roll(game, roll), do: {:ok, [{roll, nil} | game]}

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful error tuple.
  """

  @not_over "Score cannot be taken until the end of the game"

  @spec score(any) :: {:ok, integer} | {:error, String.t()}
  def score([{a, b}, _, _, _, _, _, _, _, _, _]) when a + b == 10, do: {:error, @not_over}
  def score([{_, nil}, _, _, _, _, _, _, _, _, _]), do: {:error, @not_over}
  def score([10, 10, _, _, _, _, _, _, _, _, _]), do: {:error, @not_over}
  def score([10, _, _, _, _, _, _, _, _, _]), do: {:error, @not_over}
  def score([_, _, _, _, _, _, _, _, _, _] = g), do: {:ok, do_score(g)}
  def score([_, _, _, _, _, _, _, _, _, _, _] = g), do: {:ok, do_score(g)}
  def score([_, _, _, _, _, _, _, _, _, _, _, _] = g), do: {:ok, do_score(g)}
  def score(_), do: {:error, @not_over}

  defp do_score(game), do: game |> Enum.reverse() |> do_score(0)

  defp do_score([], acc), do: acc
  defp do_score([{a, b}, 10], acc), do: acc + a + b + 10
  defp do_score([{a, b}, {c, nil}], acc), do: acc + a + b + c
  defp do_score([10, 10, {a, nil}], acc), do: acc + 10 + 10 + a
  defp do_score([10, {a, b}], acc), do: acc + 10 + a + b
  defp do_score([10, 10, 10], acc), do: acc + 10 + 10 + 10
  defp do_score([10, 10], acc), do: acc + 10 + 10
  defp do_score([10 | t], acc), do: do_score(t, acc + 10 + strike_bonus(t))
  defp do_score([{a, b} | t], acc) when a + b == 10, do: do_score(t, acc + a + b + spare_bonus(t))
  defp do_score([{a, b} | t], acc), do: do_score(t, acc + a + b)

  defp strike_bonus([10, 10 | _]), do: 10 + 10
  defp strike_bonus([10, {a, _} | _]), do: 10 + a
  defp strike_bonus([{a, b} | _]), do: a + b

  defp spare_bonus([10 | _]), do: 10
  defp spare_bonus([{a, _} | _]), do: a
end
