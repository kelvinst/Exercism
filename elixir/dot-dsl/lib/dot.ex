defmodule Dot do
  defmacro graph(do: block) do
    block
    |> process_block(Graph.new())
    |> Macro.escape()
  end

  def process_block({:__block__, _, []}, acc), do: acc
  def process_block({:__block__, _, list}, acc), do: Enum.reduce(list, acc, &process_ast/2)
  def process_block(ast, acc), do: process_ast(ast, acc)

  def process_ast({:graph, _, args}, acc) do 
    Graph.put_attrs(acc, to_attrs(args))
  end

  def process_ast({:--, _, [{left, _, _}, {right, _, args}]}, acc) do 
    acc
    |> Graph.add_node(left)
    |> Graph.add_node(right)
    |> Graph.add_edge(left, right, to_attrs(args))
  end

  def process_ast({node, _, args}, acc) when is_atom(node) do 
    Graph.add_node(acc, node, to_attrs(args))
  end

  def process_ast(_, _), do: raise ArgumentError

  defp to_attrs([attrs]) when is_list(attrs), do: attrs
  defp to_attrs([]), do: []
  defp to_attrs(Elixir), do: []
  defp to_attrs(nil), do: []
  defp to_attrs(_), do: raise ArgumentError
end
