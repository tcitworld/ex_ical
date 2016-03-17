defmodule ExIcal do
  alias ExIcal.Parser
  alias ExIcal.Recurrence
  alias ExIcal.DateParser
  alias ExIcal.Utils

  defdelegate parse(data), to: Parser
  defdelegate add_recurring_events(events, end_date), to: Recurrence
  defdelegate parse_date(date), to: DateParser, as: :parse
  defdelegate parse_date(date, timezone), to: DateParser, as: :parse
  defdelegate sort_by_date(events), to: Utils
end
