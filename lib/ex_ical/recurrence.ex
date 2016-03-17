defmodule ExIcal.Recurrence do
  use Timex

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
end
