defmodule ExIcalTest do
  use ExUnit.Case
  doctest ExIcal

  test "parse empty data" do
    assert ExIcal.parse("") == []
  end

  test "event" do
    ical = """
      BEGIN:VCALENDAR
      CALSCALE:GREGORIAN
      VERSION:2.0
      BEGIN:VEVENT
      DESCRIPTION:Let's go see Star Wars.
      DTEND:20151224T084500Z
      DTSTART:20151224T083000Z
      SUMMARY:Film with Amy and Adam
      END:VEVENT
      END:VCALENDAR
    """

    event = ExIcal.parse(ical) |> List.first

    assert event[:description] == "Let's go see Star Wars."
    assert event[:summary] == "Film with Amy and Adam"
    assert event[:start] == ExIcal.parse_date("20151224T083000Z")
    assert event[:end] == ExIcal.parse_date("20151224T084500Z")
  end

end
