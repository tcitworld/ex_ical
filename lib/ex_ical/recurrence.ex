defmodule ExIcal.Recurrence do
  use Timex

  def add_recurring_events(events, end_date \\ Date.now) do
    events ++ (events |> Enum.reduce([], fn(event, revents) ->
      case event.rrule do
        nil ->
          revents
        %{freq: "DAILY"} ->
          until = event.rrule[:until] || end_date
          days = (event.rrule[:interval] || "1") |> String.to_integer
          revents ++ (event |> add_recurring_events_for([days: days], until))
        %{freq: "MONTHLY"} ->
          until = event.rrule[:until] || end_date
          months = (event.rrule[:interval] || "1") |> String.to_integer
          revents ++ (event |> add_recurring_events_for([months: months], until))
      end
    end))
  end

  defp add_recurring_events_for(event, shift_opts, until) do
    new_event = event
    new_event = new_event |> Map.put(:start, Date.shift(event.start, shift_opts))
    new_event = new_event |> Map.put(:end, Date.shift(event.end, shift_opts))

    case Date.compare(new_event.start, until) do
     -1 -> [new_event] ++ add_recurring_events_for(new_event, shift_opts, until)
      0 -> [new_event]# ++ add_recurring_events_for(new_event, shift_opts, until)
      1 -> [new_event]
    end
  end
end
