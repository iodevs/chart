defmodule Chart.Internal.BarLine.MajorTicksText do
  @moduledoc false

  # alias Chart.Internal.Utils
  # import Chart.Internal.Guards, only: [is_nonnegative_number: 1]

  @self_key :major_ticks_text
  @x_axis :x_axis

  def new() do
    %{
      gap: 0,
      labels: :from_map,
      positions: []
    }
  end

  def add(%{axis_table: axis_table} = settings, axis \\ @x_axis)
      when is_map(settings) and is_map_key(axis_table, axis) do
    settings
    |> put_in([axis, @self_key], new())
  end

  # Setters

  @doc """
  gap ::  number
  """
  def set_gap(%{axis_table: axis_table} = settings, axis, gap)
      when is_map(settings) and is_map_key(axis_table, axis) and is_number(gap) do
    put_in(settings, [axis, @self_key, :gap], gap)
  end

  def set_labels(chart) do
    chart.settings.x_axis.major_ticks_text

    labels = get_labels(chart, chart.settings.x_axis.major_ticks_text.labels)

    updated_settings = put_in(chart.settings, [:x_axis, @self_key, :labels], labels)

    Map.put(chart, :settings, updated_settings)
  end

  def set_labels(settings, axis, labels)
      when is_map(settings) and (is_atom(labels) or is_list(labels)) do
    put_in(settings, [axis, @self_key, :labels], labels)
  end

  # Private

  defp get_labels(chart, :from_map) do
    chart.storage.data |> Enum.map(fn {k, _v} -> k end)
  end

  defp get_labels(_chart, labels) when is_list(labels) do
    labels
  end
end
