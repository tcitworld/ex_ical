ExUnit.start()

defmodule ExIcal.Test.Utils do
  def subset?(nil, nil), do: true
  def subset?(nil, _), do: false
  def subset?(_, nil), do: false
  def subset?(%{} = subset, %{} = superset) do
    superset_contains_pair = fn {k, v} ->
      %{superset | k => v} === superset
    end
    subset |> Enum.all?(superset_contains_pair)
  end

  defmacro assert_subset(subset, superset) do
    quote do
      assert subset?(unquote(subset), unquote(superset)),
        "Expected #{inspect unquote(subset)} to be a subset of #{inspect unquote(superset)}"
    end
  end
end
