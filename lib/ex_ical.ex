defmodule ExIcal do
  @moduledoc """
  iCalendar parser for [Elixir](http://elixir-lang.org).

  ## Installation

  Add ex_ical to your list of dependencies in `mix.exs`:

  ```elixir
    def deps do
      [{:ex_ical, "~> 0.0.4"}]
    end
  ```

  ## Usage

  ```elixir
    HTTPotion.get("url-for-icalendar").body
      |> ExIcal.parse
      |> ExIcal.by_range(Date.now, Date.now |> Date.shift(days: 7))
  ```
  """
  alias ExIcal.Parser
  alias ExIcal.Recurrence
  alias ExIcal.Utils

  defdelegate parse(data), to: Parser
  defdelegate add_recurring_events(events), to: Recurrence
  defdelegate add_recurring_events(events, end_date), to: Recurrence
  defdelegate sort_by_date(events), to: Utils
  defdelegate by_range(events, start_date, end_date), to: Utils
end
