defmodule Chart.Line do
  @moduledoc """
  A line chart definition structure
  """
  alias Chart.Internal.{AxisLine, GridLine, Text}
  alias Chart.Internal.Storage.Buffer
  alias Chart.Internal.AxisLine.MajorTicksText
  alias Chart.Line.{Settings, Svg}
  alias Chart.Chart

  def put(%Chart{} = chart, data) do
    chart |> Chart.put_data(data)
  end

  def render(%Chart{} = chart) do
    chart |> Svg.generate()
  end

  def setup(storage \\ Buffer) do
    storage
    |> Chart.new()
    |> Chart.put_settings(Settings.new())
    |> Chart.register([
      &MajorTicksText.recalc_range/1
    ])
  end

  #  Axis label setters

  def set_axis_label_adjust_placement(%Chart{} = chart, axis, adjust_placement) do
    apply_setter(chart, &AxisLine.Label.set_adjust_placement(&1, axis, adjust_placement))
  end

  def set_axis_label(%Chart{} = chart, axis, text) do
    apply_setter(chart, &AxisLine.Label.set_text(&1, axis, text))
  end

  def set_axis_label_placement(%Chart{} = chart, axis, placement) do
    apply_setter(chart, &AxisLine.Label.set_placement(&1, axis, placement))
  end

  #  Grid setters

  def set_grid(%Chart{} = chart, axis_grid_type) do
    apply_setter(chart, &GridLine.set_grid(&1, axis_grid_type))
  end

  def set_grid_gap(%Chart{} = chart, axis_grid_type, number) do
    apply_setter(chart, &GridLine.set_gap(&1, axis_grid_type, number))
  end

  #  Title setters

  def set_title_position(%Chart{} = chart, position) do
    apply_setter(chart, &Text.set_position(&1, :title, position))
  end

  def set_title_text(%Chart{} = chart, text) do
    apply_setter(chart, &Text.set_text(&1, :title, text))
  end

  # Private

  defp apply_setter(chart, setter) do
    Chart.put_settings(chart, setter.(chart.settings))
  end
end
