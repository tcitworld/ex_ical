defmodule ExIcal.Parser do
  alias ExIcal.DateParser
  alias ExIcal.Event

  def parse(data) do
    data |> String.split("\n") |> Enum.reduce([], fn(line, events) ->
      parse_line(String.strip(line), events)
    end)
  end

  defp parse_line("BEGIN:VEVENT" <> _, events),          do: [%Event{}] ++ events
  defp parse_line("DTSTART" <> start, events)            when length(events) > 0, do: events |> put_to_map(:start, process_date(start))
  defp parse_line("DTEND" <> endd, events)               when length(events) > 0, do: events |> put_to_map(:end, process_date(endd))
  defp parse_line("DTSTAMP" <> stamp, events)            when length(events) > 0, do: events |> put_to_map(:stamp, process_date(stamp))
  defp parse_line("SUMMARY:" <> summary, events)         when length(events) > 0, do: events |> put_to_map(:summary, summary)
  defp parse_line("DESCRIPTION:" <> description, events) when length(events) > 0, do: events |> put_to_map(:description, description)
  defp parse_line("RRULE:" <> rrule, events)             when length(events) > 0, do: events |> put_to_map(:rrule, process_rrule(rrule))
  defp parse_line(_, events), do: events

  defp put_to_map(events, key, value) do
    [ event | other ] = events
    event = %{ event | key => value}
    [event] ++ other
  end

  defp process_date(":" <> date), do: DateParser.parse(date)
  defp process_date(";" <> date) do
    [timezone, date] = date |> String.split(":")
    timezone = case timezone do
      "TZID=" <> timezone -> timezone
      _ -> "UTC"
    end
    DateParser.parse(date, timezone)
  end

  defp process_rrule(rrule) do
    rrule |> String.split(";") |> Enum.reduce(%{}, fn(rule, hash) ->
      [key, value] = rule |> String.split("=")
      case key |> String.downcase |> String.to_atom do
        :until -> hash |> Map.put(:until, DateParser.parse(value))
        :interval -> hash |> Map.put(:interval, String.to_integer(value))
        :count -> hash |> Map.put(:count, String.to_integer(value))
        key -> hash |> Map.put(key, value)
      end
    end)
  end
end
