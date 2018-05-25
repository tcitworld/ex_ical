defmodule ExIcal.Utils do
  @moduledoc """
  Contains helper functions for events lists.

  `by_range/3` filters a list of events by a date range, and `sort_by_date/1`
  sorts them by start date.
  """

  alias ExIcal.{Recurrence,Event}

  @doc """
  Returns all events that fall in the given date range, ordered by start date.

  ## Parameters
    - `events`:     Events list
    - `start_date`: Filter events after this date
    - `end_date`:   Filter events before this date
  """

  @spec by_range([%Event{}], %DateTime{}, %DateTime{}) :: [%Event{}]
  def by_range(events, start_date, end_date) do
    date_in_range = fn(event) ->
      Timex.between?(event.start, start_date, end_date, [inclusive: true]) && Timex.between?(event.end, start_date, end_date, [inclusive: true])
    end

    events
    |> Recurrence.add_recurring_events(end_date)
    |> Enum.filter(date_in_range)
    |> sort_by_date
  end

  @doc """
  Sort events by start date/time, earliest to latest.

  ## Parameters
    - `events`: Events list
  """

  @spec sort_by_date([%Event{}]) :: [%Event{}]
  def sort_by_date(events) do
    events |> Enum.sort(fn(event1, event2) ->
      Timex.before?(event1.start, event2.start)
    end)
  end
end
