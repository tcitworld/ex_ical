defmodule ExIcalTzidTest do
  use ExUnit.Case
  alias ExIcal.DateParser

  doctest ExIcal

  test "daily reccuring event with until and tzid" do
    ical = """
      BEGIN:VCALENDAR
      CALSCALE:GREGORIAN
      VERSION:2.0
      TZID:America/New_York
      BEGIN:VEVENT
      RRULE:FREQ=DAILY;UNTIL=20151231T083000Z
      DESCRIPTION:Let's go see Star Wars.
      DTEND:20151224T084500Z
      DTSTART:20151224T083000Z
      SUMMARY:Film with Amy and Adam
      END:VEVENT
      END:VCALENDAR
    """
    events = ExIcal.parse(ical) |> ExIcal.by_range(DateParser.parse("20151224T083000Z"), DateParser.parse("20161224T084500Z"))
    assert events |> Enum.count == 8

    [event|events] = events
    assert event.start == DateParser.parse("20151224T083000Z")
    [event|events] = events
    assert event.start == DateParser.parse("20151225T083000Z")
    [event|events] = events
    assert event.start == DateParser.parse("20151226T083000Z")
    [event|events] = events
    assert event.start == DateParser.parse("20151227T083000Z")
    [event|events] = events
    assert event.start == DateParser.parse("20151228T083000Z")
    [event|events] = events
    assert event.start == DateParser.parse("20151229T083000Z")
    [event|events] = events
    assert event.start == DateParser.parse("20151230T083000Z")
    [event] = events
    assert event.start == DateParser.parse("20151231T083000Z")
  end
end
