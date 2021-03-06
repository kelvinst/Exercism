defmodule BoutiqueInventory do
  def sort_by_price(inventory), do: Enum.sort_by(inventory, & &1.price)

  def with_missing_price(inventory), do: Enum.reject(inventory, & &1.price)

  def increase_quantity(item, count) do
    Map.update!(item, :quantity_by_size, fn quantity_by_size ->
      quantity_by_size
      |> Enum.map(fn {size, quantity} -> {size, quantity + count} end)
      |> Enum.into(%{})
    end)
  end

  def total_quantity(item) do
    Enum.reduce(item.quantity_by_size, 0, fn {_, quantity}, acc -> acc + quantity end)
  end
end
