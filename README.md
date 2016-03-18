# ExIcal

ICalendar parser for [Elixir](http://elixir-lang.org).

## Installation

Add ex_ical to your list of dependencies in `mix.exs`:

```elixir
  def deps do
    [{:ex_ical, "~> 0.0.1"}]
  end
```

## Usage

```elixir
  HTTPotion.get("url-for-icalendar").body
    |> ExIcal.parse
    |> ExIcal.by_range(Date.now, Date.shift(Date.now, days: 7))
```
