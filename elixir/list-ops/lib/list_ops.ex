defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l), do: count(l, 0)

  defp count([], acc), do: acc
  defp count([_ | t], acc), do: count(t, acc + 1)

  @spec reverse(list) :: list
  def reverse(l), do: reverse(l, [])

  defp reverse([], acc), do: acc
  defp reverse([h | t], acc), do: reverse(t, [h | acc])

  @spec map(list, (any -> any)) :: list
  def map(l, f), do: map(l, f, [])

  defp map([], _, acc), do: reverse(acc)
  defp map([h | t], f, acc), do: map(t, f, [f.(h) | acc])

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f), do: filter(l, f, [])

  defp filter([], _, acc), do: reverse(acc)
  defp filter([h | t], f, acc), do: if f.(h), do: filter(t, f, [h | acc]), else: filter(t, f, acc)

  @type acc :: any
  @spec foldl(list, acc, (any, acc -> acc)) :: acc
  def foldl([], acc, _), do: acc
  def foldl([h | t], acc, f), do: foldl(t, f.(h, acc), f)

  @spec foldr(list, acc, (any, acc -> acc)) :: acc
  def foldr(l, acc, f), do: l |> reverse() |> foldl(acc, f)

  @spec append(list, list) :: list
  def append(a, b), do: a |> reverse() |> do_append(b)

  defp do_append([], b), do: b
  defp do_append([h | t], b), do: do_append(t, [h | b])

  @spec concat([[any]]) :: [any]
  def concat(ll), do: foldr(ll, [], &append(&1, &2))
end
