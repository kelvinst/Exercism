defmodule FreelancerRates do
  @hours_in_day 8.0
  @billable_days_in_month 22

  def daily_rate(hourly_rate) do 
    @hours_in_day * hourly_rate
  end

  def apply_discount(before_discount, discount) do
    before_discount - ((discount / 100) * before_discount)
  end

  def monthly_rate(hourly_rate, discount) do
    @billable_days_in_month * daily_rate(hourly_rate)
    |> apply_discount(discount)
    |> ceil()
  end

  def days_in_budget(budget, hourly_rate, discount) do
    discounted_daily_rate =
      hourly_rate
      |> daily_rate()
      |> apply_discount(discount)

    Float.floor(budget / discounted_daily_rate, 1)
  end
end
