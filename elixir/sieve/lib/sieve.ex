defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit) when limit < 2, do: []
  def primes_to(limit), do: primes_to(limit, 2, [], [])

  def primes_to(limit, current, _, primes) when limit < current, do: Enum.reverse(primes)

  def primes_to(limit, current, all, primes) do
    all = current..limit//current |> Enum.concat(all) |> Enum.sort() |> Enum.uniq()
    next = next_prime(all, 1)
    primes_to(limit, next, all, [current | primes])
  end

  def next_prime([], p), do: p + 1
  def next_prime([h | t], p) when h == p + 1, do: next_prime(t, h)
  def next_prime(_, p), do: p + 1
end
