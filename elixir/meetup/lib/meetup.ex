defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date()
  def meetup(year, month, weekday, schedule) do
    date = Date.new!(year, month, 1)

    date
    |> Date.add(days_to_add(date, schedule))
    |> search(weekday)
  end

  defp days_to_add(_, :first), do: 0
  defp days_to_add(_, :second), do: 7
  defp days_to_add(_, :teenth), do: 12
  defp days_to_add(_, :third), do: 14
  defp days_to_add(_, :fourth), do: 21
  defp days_to_add(date, :last), do: Date.days_in_month(date) - 7

  defp search(date, weekday) do
    if Date.day_of_week(date) == to_int(weekday) do
      date
    else
      search(Date.add(date, 1), weekday)
    end
  end

  defp to_int(:monday), do: 1
  defp to_int(:tuesday), do: 2
  defp to_int(:wednesday), do: 3
  defp to_int(:thursday), do: 4
  defp to_int(:friday), do: 5
  defp to_int(:saturday), do: 6
  defp to_int(:sunday), do: 7
end
