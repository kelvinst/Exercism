defmodule PerfectNumbers do
  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: {:ok, atom} | {:error, String.t()}
  def classify(number) when number > 0 do
    sum = 
      number
      |> factors(number - 1, [])
      |> Enum.sum()

    cond do
      sum == number -> {:ok, :perfect}
      sum > number -> {:ok, :abundant}
      sum < number -> {:ok, :deficient}
    end
  end

  def classify(_), do: {:error, "Classification is only possible for natural numbers."}

  defp factors(_, 0, acc), do: acc
  defp factors(_, 1, acc), do: [1 | acc]
  defp factors(n, f, acc) when rem(n, f) == 0, do: factors(n, f - 1, [f | acc])
  defp factors(n, f, acc), do: factors(n, f - 1, acc)
end
