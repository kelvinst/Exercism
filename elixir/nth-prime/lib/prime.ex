defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(count) when count > 0 do
    2
    |> Stream.iterate(&next/1)
    |> Enum.at(count - 1)
  end

  defp next(x) do
    n = x + 1
    if prime?(n), do: n, else: next(n)
  end

  defp prime?(x), do: Enum.all?(2..(x-1), &(rem(x, &1) != 0))
end
