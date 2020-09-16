defmodule Chart.Internal.Storage.Queue do
  @moduledoc false

  alias Chart.Chart

  defstruct count: nil,
            data: nil

  def new() do
    %__MODULE__{
      count: 50,
      data: nil
    }
  end

  def put(%Chart{storage: storage} = chart, data) do
    chart
    |> Map.put(:storage, %__MODULE__{storage | data: merge(storage.data, data, storage.count)})
    |> apply_callbacks()
  end

  def set_count(%Chart{} = chart, count) when is_map(chart) and is_integer(count) and 1 < count do
    put_in(chart, [:storage, :count], count)
  end

  # Private

  defp apply_callbacks(%Chart{callbacks: callbacks} = chart) do
    Enum.reduce(callbacks, chart, fn cb, acc -> cb.(acc) end)
  end

  defp merge(nil, data, _count) when is_tuple(data) do
    [data]
  end

  defp merge(nil, data, _count) when is_list(data) do
    data
  end

  defp merge([first | _rest] = buffer, data, count) when length(first) < count do
    buffer
    |> Enum.zip(data)
    |> Enum.map(fn {bf, d} -> Enum.concat(bf, d) end)
  end

  defp merge(buffer, data, count) do
    buffer
    |> Enum.map(fn [_first | rest] -> rest end)
    |> merge(data, count)
  end
end
