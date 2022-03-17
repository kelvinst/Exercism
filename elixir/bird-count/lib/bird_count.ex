defmodule BirdCount do
  def today([today | _]), do: today
  def today([]), do: nil

  def increment_day_count([today | rest]), do: [today + 1 | rest]
  def increment_day_count([]), do: [1]

  def has_day_without_birds?([0 | _]), do: true
  def has_day_without_birds?([]), do: false
  def has_day_without_birds?([_ | rest]), do: has_day_without_birds?(rest)

  def total(list), do: total(list, 0)

  defp total([], acc), do: acc
  defp total([count | rest], acc), do: total(rest, acc + count)

  def busy_days(list), do: busy_days(list, 0)

  defp busy_days([], acc), do: acc
  defp busy_days([count | rest], acc) when count >= 5, do: busy_days(rest, acc + 1)
  defp busy_days([_ | rest], acc), do: busy_days(rest, acc)
end
