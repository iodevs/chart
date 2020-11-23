defmodule Chart.Internal.Storage.Buffer do
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

  defp merge(nil, data) when is_tuple(data) do
    [data]
  end

  defp merge(nil, data) when is_list(data) do
    data
  end

  defp merge(buffer, data) when is_list(buffer) and is_tuple(data) do
    merge(buffer, [data])
  end

  defp merge(buffer, data) when is_list(buffer) and is_list(data) do
    buffer
    |> Enum.zip(data)
    |> Enum.map(fn {bf, d} -> Enum.concat(bf, d) end)
  end
end
