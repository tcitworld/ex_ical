defmodule ExIcalTest do
  use ExUnit.Case
  use Timex

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
    events = ExIcal.parse(ical)

    assert events |> Enum.count == 1

    event = events |> List.first

    assert event[:description] == "Let's go see Star Wars."
    assert event[:summary] == "Film with Amy and Adam"
    assert event[:start] == ExIcal.parse_date("20151224T083000Z")
    assert event[:end] == ExIcal.parse_date("20151224T084500Z")
  end

  test "monthly reccuring event with until" do
    ical = """
      BEGIN:VCALENDAR
      CALSCALE:GREGORIAN
      VERSION:2.0
      BEGIN:VEVENT
      RRULE:FREQ=MONTHLY;UNTIL=20161224T083000Z
      DESCRIPTION:Let's go see Star Wars.
      DTEND:20151224T084500Z
      DTSTART:20151224T083000Z
      SUMMARY:Film with Amy and Adam
      END:VEVENT
      END:VCALENDAR
    """
    events = ExIcal.parse(ical) |> ExIcal.add_recurring_events(ExIcal.parse_date("20161224T083000Z")) |> ExIcal.sort_by_date
    assert events |> Enum.count == 13

    [event|events] = events
    assert event[:start] == ExIcal.parse_date("20151224T083000Z")
    [event|events] = events
    assert event[:start] == ExIcal.parse_date("20160124T083000Z")
    [event|events] = events
    assert event[:start] == ExIcal.parse_date("20160224T083000Z")
    [event|events] = events
    assert event[:start] == ExIcal.parse_date("20160324T083000Z")
    [event|events] = events
    assert event[:start] == ExIcal.parse_date("20160424T083000Z")
    [event|events] = events
    assert event[:start] == ExIcal.parse_date("20160524T083000Z")
    [event|events] = events
    assert event[:start] == ExIcal.parse_date("20160624T083000Z")
    [event|events] = events
    assert event[:start] == ExIcal.parse_date("20160724T083000Z")
    [event|events] = events
    assert event[:start] == ExIcal.parse_date("20160824T083000Z")
    [event|events] = events
    assert event[:start] == ExIcal.parse_date("20160924T083000Z")
    [event|events] = events
    assert event[:start] == ExIcal.parse_date("20161024T083000Z")
    [event|events] = events
    assert event[:start] == ExIcal.parse_date("20161124T083000Z")
    [event] = events
    assert event[:start] == ExIcal.parse_date("20161224T083000Z")
  end

end
