defmodule Chart.Internal.Storage.Tuple do
  @moduledoc false

  alias Chart.Chart

  defstruct data: nil

  def new() do
    %__MODULE__{
      data: nil
    }
  end

  def append(%Chart{storage: storage} = chart, data) do
    chart
    |> Map.put(:storage, %__MODULE__{storage | data: merge(storage.data, data)})
    |> Chart.apply_callbacks()
  end

  def put(%Chart{storage: storage} = chart, data) do
    chart
    |> Map.put(:storage, %__MODULE__{storage | data: data})
    |> Chart.apply_callbacks()
  end

  def reset(%Chart{storage: storage} = chart) do
    chart
    |> Map.put(:storage, %__MODULE__{storage | data: nil})
  end

  # Private

  defp merge(nil, data) when is_map(data) do
    sort(data)
  end

  defp merge(data, new_data) when is_list(data) and is_map(new_data) do
    data
    |> to_map()
    |> Map.merge(new_data)
    |> sort()
  end

  defp sort(data) do
    data
    |> Map.to_list()
    |> Enum.map(fn {k, v} -> {Atom.to_string(k), v} end)
    |> Enum.sort_by(&elem(&1, 0), &(String.length(&1) <= String.length(&2)))
  end

  defp to_map(data) do
    data
    |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
    |> Map.new()
  end
end
