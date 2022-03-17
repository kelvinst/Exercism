defmodule Say do
  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(number) when number in 0..999999999999 do
    {:ok, number |> eng() |> String.trim() |> String.trim("-")}
  end

  def in_english(_), do: {:error, "number is out of range"}

  defp eng(number, ignore_zero? \\ false)
  defp eng(0, true), do: ""
  defp eng(0, _), do: "zero"
  defp eng(1, _), do: "one"
  defp eng(2, _), do: "two"
  defp eng(3, _), do: "three"
  defp eng(4, _), do: "four"
  defp eng(5, _), do: "five"
  defp eng(6, _), do: "six"
  defp eng(7, _), do: "seven"
  defp eng(8, _), do: "eight"
  defp eng(9, _), do: "nine"
  defp eng(10, _), do: "ten"
  defp eng(11, _), do: "eleven"
  defp eng(12, _), do: "twelve"
  defp eng(14, _), do: "fourteen"
  defp eng(x, _) when x < 20, do: "#{prefix(rem(x, 10))}teen"
  defp eng(x, _) when x < 100, do: "#{prefix(div(x, 10))}ty-#{eng(rem(x, 10), true)}"
  defp eng(x, _) when x < 1000, do: "#{eng(div(x, 100))} hundred #{eng(rem(x, 100), true)}"
  defp eng(x, _) when x < 1000000, do: "#{eng(div(x, 1000))} thousand #{eng(rem(x, 1000), true)}"

  defp eng(x, _) when x < 1000000000 do 
    "#{eng(div(x, 1000000))} million #{eng(rem(x, 1000000), true)}"
  end

  defp eng(x, _) when x < 1000000000000 do 
    "#{eng(div(x, 1000000000))} billion #{eng(rem(x, 1000000000), true)}"
  end

  defp prefix(2), do: "twen"
  defp prefix(3), do: "thir"
  defp prefix(4), do: "for"
  defp prefix(5), do: "fif"
  defp prefix(6), do: "six"
  defp prefix(7), do: "seven"
  defp prefix(8), do: "eigh"
  defp prefix(9), do: "nine"
end
