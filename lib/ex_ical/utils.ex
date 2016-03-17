defmodule ExIcal.Utils do
  alias ExIcal.Recurence
  use Timex

  def get_events(events, start_date, end_date) do
    (events ++ Recurrence.add_recurring_events(events, end_date)) |> Enum.filter(fn(event) ->
      #Date.after?(event[:start], start_date) && Date.before?(event[:start], end_date) && Date.after?(event[:end], start_date) && Date.before?(event[:end], end_date)
      true
    end)
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
