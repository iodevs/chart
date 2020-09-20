defmodule Chart.Internal.Storage.Tuple do
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
    |> Map.put(:storage, %__MODULE__{storage | data: merge(storage.data, data)})
    |> Chart.apply_callbacks()
  end

  # Private

  defp merge(nil, data) when is_map(data) do
    data
  end

  defp merge(data, new_data) when is_map(data) and is_map(new_data) do
    Map.merge(data, new_data)
  end
end
