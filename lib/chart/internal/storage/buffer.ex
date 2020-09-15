defmodule Chart.Internal.Storage.Buffer do
  @moduledoc false

  alias Chart.Chart

  @self_key :storage

  def new() do
    %{
      callbacks: [],
      type: __MODULE__
    }
  end

  def add(settings) when is_map(settings) do
    put_in(settings, [@self_key], new())
  end

  def put(%Chart{data: buffer, settings: %{storage: storage}} = chart, data) do
    merged_data = merge(buffer, data)
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

  # Setters

  def set_callbacks(settings, callbacks) when is_map(settings) and is_list(callbacks) do
    put_in(settings, [@self_key, :callbacks], callbacks)
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
