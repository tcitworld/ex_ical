defmodule ExIcalTest do
  use ExUnit.Case
  alias ExIcal.DateParser

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
      UID:19960401T080045Z-4000F192713-0052@host1.com
      END:VEVENT
      END:VCALENDAR
    """
    events = ExIcal.parse(ical)

    assert events |> Enum.count == 1

    event = events |> List.first

    assert event.description == "Let's go see Star Wars."
    assert event.summary == "Film with Amy and Adam"
    assert event.start == DateParser.parse("20151224T083000Z")
    assert event.end == DateParser.parse("20151224T084500Z")
    assert event.uid == "19960401T080045Z-4000F192713-0052@host1.com"
  end
end
