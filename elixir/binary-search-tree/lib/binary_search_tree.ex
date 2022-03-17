defmodule BinarySearchTree do
  @type bst_node :: %{data: any, left: bst_node | nil, right: bst_node | nil}

  @doc """
  Create a new Binary Search Tree with root's value as the given 'data'
  """
  @spec new(any) :: bst_node
  def new(data), do: %{data: data, left: nil, right: nil}

  @doc """
  Creates and inserts a node with its value as 'data' into the tree.
  """
  @spec insert(bst_node, any) :: bst_node
  def insert(nil, data), do: new(data)
  def insert(%{data: o} = n, d) when d <= o, do: Map.update!(n, :left, &insert(&1, d))
  def insert(%{data: o} = n, d) when d > o, do: Map.update!(n, :right, &insert(&1, d))

  @doc """
  Traverses the Binary Search Tree in order and returns a list of each node's data.
  """
  @spec in_order(bst_node) :: [any]
  def in_order(node), do: in_order(node, [])

  def in_order(nil, acc), do: acc
  def in_order(%{data: data, left: l, right: r}, acc), do: in_order(l, [data | in_order(r, acc)])
end
