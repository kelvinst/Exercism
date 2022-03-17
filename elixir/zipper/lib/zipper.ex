defmodule Zipper do
  defstruct [:current, :up, :path]

  @type t :: %Zipper{current: BinTree.t(), path: :left | :right | nil, up: Zipper.t() | nil}
  
  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(bin_tree), do: %Zipper{current: bin_tree}

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(%Zipper{current: tree, up: nil}), do: tree
  def to_tree(%Zipper{up: up}), do: to_tree(up)

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(%Zipper{current: tree}), do: tree.value

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(%Zipper{current: %{left: nil}}), do: nil
  def left(%Zipper{current: %{left: l}} = z), do: %Zipper{up: z, path: :left, current: l}

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(%Zipper{current: %{right: nil}}), do: nil
  def right(%Zipper{current: %{right: r}} = z), do: %Zipper{up: z, path: :right, current: r}

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(%Zipper{up: up}), do: up

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(%Zipper{current: tree} = zipper, value) do
    tree = %{tree | value: value}
    %{zipper | current: tree, up: set_up(zipper, tree)}
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(%Zipper{current: tree} = zipper, left) do
    tree = %{tree | left: left}
    %{zipper | current: tree, up: set_up(zipper, tree)}
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(%Zipper{current: tree} = zipper, right) do
    tree = %{tree | right: right}
    %{zipper | current: tree, up: set_up(zipper, tree)}
  end

  defp set_up(%Zipper{up: nil}, _), do: nil
  defp set_up(%Zipper{up: up, path: :left}, left), do: set_left(up, left)
  defp set_up(%Zipper{up: up, path: :right}, right), do: set_right(up, right)
end
