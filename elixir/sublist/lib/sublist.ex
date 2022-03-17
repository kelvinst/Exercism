defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, b) do 
    cond do
      a == b -> :equal
      contains?(a, b) -> :superlist 
      contains?(b, a) -> :sublist 
      true -> :unequal
    end
  end

  defp contains?(a, b), do: contains?(a, b, length(b))

  defp contains?(_, [], _), do: true
  defp contains?([], _, _), do: false

  defp contains?(a, b, lb) do
    if starts_with?(a, b, lb) do
      true
    else
      contains?(tl(a), b, lb)
    end
  end

  defp starts_with?(_, _, 0), do: true
  defp starts_with?([h | t], [h | tt], l), do: starts_with?(t, tt, l - 1)
  defp starts_with?(_, _, _), do: false
end
