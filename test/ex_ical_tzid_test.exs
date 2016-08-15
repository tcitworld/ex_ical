defmodule ExIcalTzidTest do
  use ExUnit.Case
  alias ExIcal.DateParser

  test "daily reccuring event with until and tzid" do
    tzid = "Europe/Berlin"
    ical = """
      BEGIN:VCALENDAR
      CALSCALE:GREGORIAN
      VERSION:2.0
      TZID:#{tzid}
      BEGIN:VEVENT
      RRULE:FREQ=DAILY;UNTIL=20151231T083000
      DESCRIPTION:Let's go see Star Wars.
      DTEND:20151224T084500
      DTSTART:20151224T083000
      SUMMARY:Film with Amy and Adam
      END:VEVENT
      END:VCALENDAR
    """
    events = ExIcal.parse(ical) |> ExIcal.by_range(DateParser.parse("20151224T083000", tzid), DateParser.parse("20161224T084500", tzid))
    assert events |> Enum.count == 8

    [event|events] = events
    assert event.start == DateParser.parse("20151224T083000", tzid)
    [event|events] = events
    assert event.start == DateParser.parse("20151225T083000", tzid)
    [event|events] = events
    assert event.start == DateParser.parse("20151226T083000", tzid)
    [event|events] = events
    assert event.start == DateParser.parse("20151227T083000", tzid)
    [event|events] = events
    assert event.start == DateParser.parse("20151228T083000", tzid)
    [event|events] = events
    assert event.start == DateParser.parse("20151229T083000", tzid)
    [event|events] = events
    assert event.start == DateParser.parse("20151230T083000", tzid)
    [event] = events
    assert event.start == DateParser.parse("20151231T083000", tzid)
  end
end
