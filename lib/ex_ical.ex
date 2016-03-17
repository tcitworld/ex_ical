defmodule ExIcal do
  alias ExIcal.Parser
  alias ExIcal.Recurrence
  alias ExIcal.DateParser
  alias ExIcal.Utils

  def parse(data), do: Parser.parse(data)
  def add_recurring_events(events, end_date), do: Recurrence.add_recurring_events(events, end_date)
  def parse_date(date), do: DateParser.parse(date)
  def parse_date(date, timezone), do: DateParser.parse(date, timezone)
  def sort_by_date(events), do: Utils.sort_by_date(events)
end
