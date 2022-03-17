defmodule Queens do
  @type t :: %Queens{black: {integer, integer}, white: {integer, integer}}
  defstruct [:white, :black]

  @doc """
  Creates a new set of Queens
  """
  @spec new(Keyword.t()) :: Queens.t()
  def new(opts \\ []), do: struct!(Queens, validate_opts!(opts))

  @doc """
  Gives a string representation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(queens) do
    chars = for x <- 0..7, y <- 0..7, do: char(queens, x, y)

    chars
    |> Enum.chunk_every(8)
    |> Enum.map(&Enum.join(&1, " "))
    |> Enum.join("\n")
  end

  defp char(%Queens{white: {x, y}}, x, y), do: "W"
  defp char(%Queens{black: {x, y}}, x, y), do: "B"
  defp char(%Queens{}, _, _), do: "_"

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(%Queens{white: {wx, wy}, black: {bx, by}}) do
    (wx == bx) or (wy == by) or (abs(wx - bx) == abs(wy - by))
  end

  def can_attack?(_), do: false

  defp validate_opts!(opts) do 
    if opts[:white] == opts[:black], do: raise ArgumentError
    Enum.map(opts, &validate_opt!/1)
  end

  defp validate_opt!({k, _}) when k not in ~w(white black)a, do: raise ArgumentError
  defp validate_opt!({k, {x, y}}) when x in 0..7 and y in 0..7, do: {k, {x, y}}
  defp validate_opt!(_), do: raise ArgumentError
end
