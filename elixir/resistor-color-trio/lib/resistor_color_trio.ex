defmodule ResistorColorTrio do
  @colors %{
    black: 0,
    brown: 1,
    red: 2,
    orange: 3,
    yellow: 4,
    green: 5,
    blue: 6,
    violet: 7,
    grey: 8,
    white: 9
  }

  @doc """
  Calculate the resistance value in ohm or kiloohm from resistor colors
  """
  @spec label(colors :: [atom]) :: {integer, :ohms | :kiloohms}
  def label([x, y, z]) do
    ohms = String.to_integer("#{@colors[x]}#{@colors[y]}#{zeros(@colors[z], "")}")

    if ohms > 1000 do
      {div(ohms, 1000), :kiloohms}
    else
      {ohms, :ohms}
    end
  end

  defp zeros(0, acc), do: acc
  defp zeros(n, acc), do: zeros(n - 1, "0" <> acc)
end
