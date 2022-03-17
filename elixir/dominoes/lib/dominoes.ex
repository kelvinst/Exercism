defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino] | []) :: boolean
  def chain?([]), do: true
  def chain?([{x, x}]), do: true
  def chain?([{_, _}]), do: false
  def chain?([h | t]), do: chain?(t, [], h, h, false)

  defp chain?([{x, y}], [], {y, _}, {_, x}, _), do: true
  defp chain?([{_, x} = h | t], r, {x, _}, f, _), do: chain?(t ++ r, [], h, f, false)
  defp chain?([{_, x} | _] = l, r, p, f, r?), do: find_dup(l, x, [], r, p, f, r?)
  defp chain?([], r, p, f, false), do: r |> Enum.map(&reverse/1) |> chain?([], p, f, true)
  defp chain?(_, _, _, _, _), do: false

  defp find_dup([], _, [h | t], r, p, f, r?), do: chain?(t, [h | r], p, f, r?)
  defp find_dup([{x, x} = h | t], x, l, r, _, f, _), do: chain?(t ++ l ++ r, [], h, f, false)
  defp find_dup([h | t], x, l, r, p, f, r?), do: find_dup(t, x, [h | l], r, p, f, r?)

  defp reverse({x, y}), do: {y, x}
end
