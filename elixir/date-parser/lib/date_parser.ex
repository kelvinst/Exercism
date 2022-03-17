defmodule DateParser do
  @day_names ~w(
    Monday
    Tuesday
    Wednesday
    Thursday
    Friday
    Saturday
    Sunday
  )

  @month_names ~w(
    January
    February
    March
    April
    May
    June
    July
    August
    September
    October
    November
    December
  )

  def day, do: "(0?|[1-3])\\d"

  def month, do: "(0?|1)\\d"

  def year, do: "\\d{4}"

  def day_names, do: "(#{Enum.join(@day_names, "|")})"

  def month_names, do: "(#{Enum.join(@month_names, "|")})"

  def capture_day, do: "(?<day>#{day()})"

  def capture_month, do: "(?<month>#{month()})"

  def capture_year, do: "(?<year>#{year()})"

  def capture_day_name, do: "(?<day_name>#{day_names()})"

  def capture_month_name, do: "(?<month_name>#{month_names()})"

  def capture_numeric_date, do: "#{capture_day()}/#{capture_month()}/#{capture_year()}"

  def capture_month_name_date, do: "#{capture_month_name()} #{capture_day()}, #{capture_year()}"

  def capture_day_month_name_date, do: "#{capture_day_name()}, #{capture_month_name_date()}"

  def match_numeric_date, do: Regex.compile!("^#{capture_numeric_date()}$")

  def match_month_name_date, do: Regex.compile!("^#{capture_month_name_date()}$")

  def match_day_month_name_date, do: Regex.compile!("^#{capture_day_month_name_date()}$")
end
