defmodule ExIcal do
  use Timex

  # --- parse ---

  def parse(data) do
    data |> String.split("\n") |> Enum.reduce([], fn(line, events) ->
      parse_line(String.strip(line), events)
    end)
  end

  defp parse_line("BEGIN:VEVENT" <> _, events),          do: [%{}] ++ events
  defp parse_line("DTSTART" <> start, events)            when length(events) > 0, do: events |> put_to_map(:start, process_date(start))
  defp parse_line("DTEND" <> endd, events)               when length(events) > 0, do: events |> put_to_map(:end, process_date(endd))
  defp parse_line("DTSTAMP" <> stamp, events)            when length(events) > 0, do: events |> put_to_map(:stamp, process_date(stamp))
  defp parse_line("SUMMARY:" <> summary, events)         when length(events) > 0, do: events |> put_to_map(:summary, summary)
  defp parse_line("DESCRIPTION:" <> description, events) when length(events) > 0, do: events |> put_to_map(:description, description)
  defp parse_line("RRULE:" <> rrule, events)             when length(events) > 0, do: events |> put_to_map(:rrule, process_rrule(rrule))
  defp parse_line(_, events), do: events

  defp put_to_map(events, key, value) do
    [ event | other ] = events
    event = event |> Map.put(key, value)
    [event] ++ other
  end

  defp process_date(":" <> date), do: parse_date(date)
  defp process_date(";" <> date) do
    [timezone, date] = date |> String.split(":")
    timezone = case timezone do
      "TZID=" <> timezone -> timezone
      _ -> "UTC"
    end
    parse_date(date, timezone)
  end

  defp process_rrule(rrule) do
    rrule |> String.split(";") |> Enum.reduce(%{}, fn(rule, hash) ->
      [key, value] = rule |> String.split("=")
      case key |> String.downcase |> String.to_atom do
        :until -> hash |> Map.put(:until, parse_date(value))
        key -> hash |> Map.put(key, value)
      end
    end)
  end

  # --- date parse ---
  def parse_date(<< year :: binary-size(4), month :: binary-size(2), day :: binary-size(2), "T",
                        hour :: binary-size(2), minutes :: binary-size(2), seconds :: binary-size(2), "Z" >>) do
      %DateTime{year: year |> String.to_integer, month: month |> String.to_integer, day: day |> String.to_integer,
                hour: hour |> String.to_integer, minute: minutes |> String.to_integer, second: seconds |> String.to_integer, timezone: %TimezoneInfo{abbreviation: "UTC"}}
  end

  def parse_date(<< year :: binary-size(4), month :: binary-size(2), day :: binary-size(2), "Z" >>) do
      %DateTime{year: year |> String.to_integer, month: month |> String.to_integer, day: day |> String.to_integer, timezone: %TimezoneInfo{abbreviation: "UTC"}}
  end

  def parse_date(<< year :: binary-size(4), month :: binary-size(2), day :: binary-size(2), "T",
                        hour :: binary-size(2), minutes :: binary-size(2), seconds :: binary-size(2) >>, timezone) do
      %DateTime{year: year |> String.to_integer, month: month |> String.to_integer, day: day |> String.to_integer,
                hour: hour |> String.to_integer, minute: minutes |> String.to_integer, second: seconds |> String.to_integer, timezone: %TimezoneInfo{abbreviation: timezone}}
  end

  def parse_date(<< year :: binary-size(4), month :: binary-size(2), day :: binary-size(2) >>, timezone) do
      %DateTime{year: year |> String.to_integer, month: month |> String.to_integer, day: day |> String.to_integer, timezone: %TimezoneInfo{abbreviation: timezone}}
  end

  # --- get_events ---

  def get_events(events, start_date, end_date) do
    (events ++ add_recurring_events(events, end_date)) |> Enum.filter(fn(event) ->
      #Date.after?(event[:start], start_date) && Date.before?(event[:start], end_date) && Date.after?(event[:end], start_date) && Date.before?(event[:end], end_date)
      true
    end)
  end

  def add_recurring_events(events, end_date \\ Date.now) do
    events ++ (events |> Enum.reduce([], fn(event, revents) ->
      case event[:rrule] do
        nil ->
          revents
        _ ->
          until = event[:rrule][:until] || end_date
          revents ++ (event |> add_recurring_events_for(event[:rrule][:freq], until))
      end
    end))
  end

  defp add_recurring_events_for(event, "DAILY" = rule, until) do
    days = (event[:rrule][:interval] || "1") |> String.to_integer

    new_event = event
    new_event = new_event |> Map.put(:start, Date.shift(event[:start], days: days))
    new_event = new_event |> Map.put(:end, Date.shift(event[:end], days: days))

    case Date.compare(new_event[:start], until) do
     -1 -> [new_event] ++ add_recurring_events_for(new_event, rule, until)
      0 -> [new_event] ++ add_recurring_events_for(new_event, rule, until)
      1 -> [new_event]
    end
  end

  defp add_recurring_events_for(event, "WEEKLY" = rule, until) do
    days = (event[:rrule][:interval] || "1") |> String.to_integer

    new_event = event
    new_event = new_event |> Map.put(:start, Date.shift(event[:start], days: days * 7))
    new_event = new_event |> Map.put(:end, Date.shift(event[:end], days: days * 7))

    case Date.compare(new_event[:start], until) do
     -1 -> [new_event] ++ add_recurring_events_for(new_event, rule, until)
      0 -> [new_event] ++ add_recurring_events_for(new_event, rule, until)
      1 -> [new_event]
    end
  end

  defp add_recurring_events_for(event, "MONTHLY" = rule, until) do
    months = (event[:rrule][:interval] || "1") |> String.to_integer

    new_event = event
    new_event = new_event |> Map.put(:start, Date.shift(event[:start], months: months))
    new_event = new_event |> Map.put(:end, Date.shift(event[:end], months: months))

    case Date.compare(new_event[:start], until) do
     -1 -> [new_event] ++ add_recurring_events_for(new_event, rule, until)
      0 -> [new_event] #++ add_recurring_events_for(new_event, rule, until)
      1 -> [new_event]
    end
  end

  def sort_by_date(events) do
    events |> Enum.sort(fn(e1, e2) ->
      case Date.compare(e1[:start], e2[:start]) do
       -1 -> true
        0 -> true
        1 -> false
      end
    end)

  end
end
