defmodule Garden do
  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """

  @names ~w(alice bob charlie david eve fred ginny harriet ileana joseph kincaid larry)a

  @spec info(String.t(), list) :: map
  def info(info_string, names \\ @names) do
    children = 
      names
      |> Enum.map(&{&1, {}})
      |> Enum.into(%{})

    info_string
    |> String.split("\n")
    |> Enum.reduce(children, &row_info(&1, Enum.sort(names), &2))
  end

  def row_info(<<>>, _, acc), do: acc

  def row_info(<<s1::integer, s2::integer, st::binary>>, [n | nt], acc) do 
    new_acc = Map.update!(acc, n, fn tuple ->
      tuple
      |> Tuple.append(seed(s1))
      |> Tuple.append(seed(s2))
    end)

    row_info(st, nt, new_acc)
  end

  defp seed(?C), do: :clover
  defp seed(?G), do: :grass
  defp seed(?R), do: :radishes
  defp seed(?V), do: :violets
end
