defmodule ExIcal.DateParser do
  use Timex

  def parse(data, tzid \\ nil)

  # Date Format: "19690620T201804Z", Timezone: *
  def parse(<< year :: binary-size(4), month :: binary-size(2), day :: binary-size(2), "T",
               hour :: binary-size(2), minutes :: binary-size(2), seconds :: binary-size(2), "Z" >>,
               _timezone) do
    {date, time} = {{year, month, day}, {hour, minutes, seconds}}
    datetime_from_params(date, time, :utc)
  end

  # Date Format: "19690620T201804", Timezone: nil
  def parse(<< year :: binary-size(4), month :: binary-size(2), day :: binary-size(2), "T",
               hour :: binary-size(2), minutes :: binary-size(2), seconds :: binary-size(2) >>,
               nil) do
    {date, time} = {{year, month, day}, {hour, minutes, seconds}}
    datetime_from_params(date, time)
  end

  # Date Format: "19690620T201804", Timezone: *
  def parse(<< year :: binary-size(4), month :: binary-size(2), day :: binary-size(2), "T",
               hour :: binary-size(2), minutes :: binary-size(2), seconds :: binary-size(2) >>,
               timezone) do
    {date, time} = {{year, month, day}, {hour, minutes, seconds}}
    datetime_from_params(date, time, timezone)
  end

  # Date Format: "19690620Z", Timezone: *
  def parse(<< year :: binary-size(4), month :: binary-size(2), day :: binary-size(2), "Z" >>, _timezone) do
    {date, time} = {{year, month, day}, {}}
    datetime_from_params(date, time)
  end

  # Date Format: "19690620", Timezone: *
  def parse(<< year :: binary-size(4), month :: binary-size(2), day :: binary-size(2) >>, _timezone) do
    {date, time} = {{year, month, day}, {}}
    datetime_from_params(date, time)
  end

  # Takes a date, time, and timezone and returns a %Timex.DateTime{}.
  #
  # Date is required and must be a tuple in the format {year, month, day}.
  # Time may be en empty tuple, but to be included, it must be in the format
  # {hour, minute, second}. Timezone is also optional and defaults to :utc.

  @spec datetime_from_params(tuple, tuple, any) :: %Timex.DateTime{}
  defp datetime_from_params(date, time, timezone \\ nil)
  defp datetime_from_params({year, month, day} = date, {hour, minute, second} = time, nil) do
    %DateTime{
      year:   year   |> String.to_integer,
      month:  month  |> String.to_integer,
      day:    day    |> String.to_integer,
      hour:   hour   |> String.to_integer,
      minute: minute |> String.to_integer,
      second: second |> String.to_integer,
      timezone: Timezone.local
    }
  end
  defp datetime_from_params({year, month, day}, {}, nil) do
    %DateTime{
      year:     year  |> String.to_integer,
      month:    month |> String.to_integer,
      day:      day   |> String.to_integer,
      timezone: Timezone.local
    }
  end
  defp datetime_from_params(date, time, tzid) do
    timezone = Timezone.get tzid
    %{datetime_from_params(date, time) | timezone: timezone}
  end
end
