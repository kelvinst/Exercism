defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number), do: factors_for(number, 2, [])

  defp factors_for(1, _, acc), do: Enum.reverse(acc)
  defp factors_for(n, p, acc) when n < p * p, do: Enum.reverse(acc, [n])
  defp factors_for(n, p, acc) when rem(n, p) == 0, do: factors_for(div(n, p), p, [p | acc])
  defp factors_for(n, p, acc), do: factors_for(n, p + 1, acc)
end
