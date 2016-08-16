defmodule ExIcal.DateParser do
  use Timex

  def parse(data, tzid \\ nil)

  # Date Format: "19690620T201804Z", Timezone: *
  def parse(<< year :: binary-size(4), month :: binary-size(2), day :: binary-size(2), "T",
               hour :: binary-size(2), minutes :: binary-size(2), seconds :: binary-size(2), "Z" >>,
               _timezone) do
    date = {year, month, day}
    time = {hour, minutes, seconds}

    {to_integers(date), to_integers(time)}
    |> Date.from(:utc)
  end

  # Date Format: "19690620T201804", Timezone: nil
  def parse(<< year :: binary-size(4), month :: binary-size(2), day :: binary-size(2), "T",
               hour :: binary-size(2), minutes :: binary-size(2), seconds :: binary-size(2) >>,
               nil) do
    date = {year, month, day}
    time = {hour, minutes, seconds}

    {to_integers(date), to_integers(time)}
    |> Date.from(:local)
  end

  # Date Format: "19690620T201804", Timezone: *
  def parse(<< year :: binary-size(4), month :: binary-size(2), day :: binary-size(2), "T",
               hour :: binary-size(2), minutes :: binary-size(2), seconds :: binary-size(2) >>,
               timezone) do
    date = {year, month, day}
    time = {hour, minutes, seconds}

    {to_integers(date), to_integers(time)}
    |> Date.from(timezone)
  end

  # Date Format: "19690620Z", Timezone: *
  def parse(<< year :: binary-size(4), month :: binary-size(2), day :: binary-size(2), "Z" >>, _timezone) do
    {year, month, day}
    |> to_integers
    |> Date.from(:local)
  end

  # Date Format: "19690620", Timezone: *
  def parse(<< year :: binary-size(4), month :: binary-size(2), day :: binary-size(2) >>, _timezone) do
    {year, month, day}
    |> to_integers
    |> Date.from(:local)
  end

  @spec to_integers({String.t, String.t, String.t}) :: {integer, integer, integer}
  defp to_integers({str1, str2, str3}) do
    {
      String.to_integer(str1),
      String.to_integer(str2),
      String.to_integer(str3)
    }
  end
end
