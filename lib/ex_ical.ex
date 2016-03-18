defmodule ExIcal do
  alias ExIcal.Parser
  alias ExIcal.Recurrence
  alias ExIcal.Utils

  defdelegate parse(data), to: Parser
  defdelegate add_recurring_events(events), to: Recurrence
  defdelegate add_recurring_events(events, end_date), to: Recurrence
  defdelegate sort_by_date(events), to: Utils
  defdelegate by_range(events, start_date, end_date), to: Utils
end
