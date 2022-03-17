defmodule BeerSong do
  @doc """
  Get a single verse of the beer song
  """
  @spec verse(integer) :: String.t()
  def verse(n) do
    """
    #{n |> bottles() |> String.capitalize()} of beer on the wall, #{bottles(n)} of beer.
    #{action(n)}, #{n |> next() |> bottles()} of beer on the wall.
    """
  end

  @doc """
  Get the entire beer song for a given range of numbers of bottles.
  """
  @spec lyrics(Range.t()) :: String.t()
  def lyrics(range \\ 99..0) do
    range
    |> Enum.map(&verse/1)
    |> Enum.join("\n")
  end

  defp bottles(0), do: "no more bottles"
  defp bottles(1), do: "1 bottle"
  defp bottles(n), do: "#{n} bottles"

  defp action(0), do: "Go to the store and buy some more"
  defp action(n), do: "Take #{subject(n)} down and pass it around"

  defp subject(1), do: "it"
  defp subject(_), do: "one"

  defp next(0), do: 99
  defp next(n), do: n - 1
end
