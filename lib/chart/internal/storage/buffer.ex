defmodule Chart.Internal.Storage.Buffer do
  @moduledoc false

  alias Chart.Chart

  defstruct data: nil

  def new() do
    %__MODULE__{
      data: nil
    }
  end

  def put(%Chart{storage: storage} = chart, data) do
    chart
    # |> put_in([:storage, :data], merge(chart.storage.data, data))
    |> Map.put(:storage, %__MODULE__{storage | data: merge(storage.data, data)})
    |> Chart.apply_callbacks()
  end

  # Private

  defp merge(nil, data) when is_tuple(data) do
    [data]
  end

  defp merge(nil, data) when is_list(data) do
    data
  end

  defp merge(buffer, data) when is_list(buffer) and (is_tuple(data) or is_list(data)) do
    buffer
    |> Enum.zip(data)
    |> Enum.map(fn {bf, d} -> Enum.concat(bf, d) end)
  end
end
