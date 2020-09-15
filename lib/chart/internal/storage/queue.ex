defmodule Chart.Internal.Storage.Queue do
  @moduledoc false

  alias Chart.Chart

  @self_key :storage

  def new() do
    %{
      callbacks: [],
      count: 10,
      type: __MODULE__
    }
  end

  def add(settings) when is_map(settings) do
    put_in(settings, [@self_key], new())
  end

  def put(%Chart{data: buffer, settings: %{storage: storage}} = chart, data) do
    merged_data = merge(buffer, data, storage.count)
    {x_data, y_data} = merged_data |> List.flatten() |> Enum.unzip()

    updated_settings =
      storage.callbacks
      |> Enum.zip([x_data, y_data])
      |> Enum.reduce(chart.settings, fn {callback, data}, settings ->
        callback.(settings, Enum.min_max(data))
      end)

    chart
    |> Chart.put_settings(updated_settings)
    |> Chart.put_data(merged_data)
  end

  def set_count(settings, count) when is_map(settings) and is_integer(count) and 1 < count do
    put_in(settings, [@self_key, :count], count)
  end

  # Private

  defp merge(nil, data, _count) when is_tuple(data) do
    [data]
  end

  defp merge(nil, data, _count) when is_list(data) do
    data
  end

  defp merge([first | _rest] = buffer, data, count) when length(first) <= count do
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
