defmodule Spiral do
  @doc """
  Given the dimension, return a square matrix of numbers in clockwise spiral order.
  """
  @spec matrix(dimension :: integer) :: list(list(integer))
  def matrix(0), do: []
  def matrix(n), do: n |> steps(n, 1, []) |> transform([])

  def steps(_, 0, _, acc), do: acc
  def steps(x, y, v, acc), do: steps(y, x - 1, v + y, [Enum.to_list(v..(v + y - 1)) | acc])

  def transform([h], acc), do: [h | acc]
  def transform([h | t], acc), do: transform(t, rotate([h | acc]))

  defp rotate(l), do: l |> Enum.zip_with(& &1) |> Enum.map(&Enum.reverse/1) 
end
