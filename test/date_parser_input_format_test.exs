defmodule DateParserInputFormatTest do
  use ExUnit.Case
  use Timex

  alias ExIcal.DateParser

  doctest DateParser

  allowed_date_formats = [
    "19690620",
    "19690620Z",
    "19690620T201804Z",
  ]

  allowed_date_formats |> Enum.each(fn(date) ->
    test "DateParser.parse/1 (date format: #{date})" do
      parsed_date = DateParser.parse unquote(date)
      assert %{year: 1969, month: 6, day: 20,
               timezone: %{abbreviation: "UTC"}} = parsed_date
    end

    test "DateParser.parse/2 (timezone: nil, date format: #{date})" do
      parsed_date = DateParser.parse(unquote(date), nil)
      assert %{year: 1969, month: 6, day: 20,
               timezone: %{abbreviation: "UTC"}} = parsed_date
    end

    test "DateParser.parse/2 (timezone: :utc, date format: #{date})" do
      parsed_date = DateParser.parse(unquote(date), :utc)
      assert %{year: 1969, month: 6, day: 20,
               timezone: %{abbreviation: "UTC"}} = parsed_date
    end
  end)
end
