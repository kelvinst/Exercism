defmodule KitchenCalculator do
  def get_volume({_, volume}), do: volume

  def to_milliliter({unit, volume}), do: {:milliliter, volume * conversion_rate(unit)}

  defp conversion_rate(:cup), do: 240
  defp conversion_rate(:fluid_ounce), do: 30
  defp conversion_rate(:teaspoon), do: 5
  defp conversion_rate(:tablespoon), do: 15
  defp conversion_rate(:milliliter), do: 1

  def from_milliliter({:milliliter, volume}, unit), do: {unit, volume / conversion_rate(unit)}

  def convert(volume_pair, unit) do
    volume_pair
    |> to_milliliter()
    |> from_milliliter(unit)
  end
end
