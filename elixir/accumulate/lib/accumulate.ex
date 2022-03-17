defmodule Accumulate do
  @doc """
    Given a list and a function, apply the function to each list item and
    replace it with the function's return value.

    Returns a list.

    ## Examples

      iex> Accumulate.accumulate([], fn(x) -> x * 2 end)
      []

      iex> Accumulate.accumulate([1, 2, 3], fn(x) -> x * 2 end)
      [2, 4, 6]

  """

  @spec accumulate(list, (any -> any)) :: list
  def accumulate(list, fun), do: accumulate(list, fun, [])

  defp accumulate([], _, acc), do: reverse(acc, [])
  defp accumulate([h | t], fun, acc), do: accumulate(t, fun, [fun.(h) | acc])

  defp reverse([], acc), do: acc
  defp reverse([h | t], acc), do: reverse(t, [h | acc])
end
