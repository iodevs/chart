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

  def append(%Chart{storage: storage} = chart, data) do
    chart
    |> Map.put(:storage, %__MODULE__{storage | data: merge(storage.data, data, storage.count)})
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

  def set_count(%Chart{storage: storage} = chart, count)
      when is_map(chart) and is_integer(count) and 1 < count do
    Map.put(chart, :storage, %__MODULE__{storage | count: count})
  end

  # Private

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
