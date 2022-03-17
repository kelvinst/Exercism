defmodule LibraryFees do
  def datetime_from_string(string), do: NaiveDateTime.from_iso8601!(string)

  def before_noon?(datetime) do
    compared_to_noon =
      datetime
      |> NaiveDateTime.to_time()
      |> Time.compare(~T[12:00:00]) 

    compared_to_noon == :lt
  end

  def return_date(checkout_datetime) do
    days_to_add = if before_noon?(checkout_datetime), do: 28, else: 29

    checkout_datetime
    |> NaiveDateTime.to_date()
    |> Date.add(days_to_add)
  end

  def days_late(planned_return_date, actual_return_datetime) do
    days_late =
      actual_return_datetime
      |> NaiveDateTime.to_date()
      |> Date.diff(planned_return_date)

    if days_late > 0, do: days_late, else: 0
  end

  def monday?(datetime) do
    day_of_week = 
      datetime
      |> NaiveDateTime.to_date()
      |> Date.day_of_week() 

    day_of_week == 1
  end

  def calculate_late_fee(checkout, return, rate) do
    actual_return_datetime = datetime_from_string(return)
    discount = discount(actual_return_datetime)

    days_late = 
      checkout
      |> datetime_from_string()
      |> return_date()
      |> days_late(actual_return_datetime)

    floor(days_late * rate * (1 - discount))
  end

  defp discount(actual_return_datetime) do
    if monday?(actual_return_datetime) do
      0.5
    else 
      0
    end
  end
end
