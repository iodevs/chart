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
    settings = chart.settings |> AxisLine.Label.set_adjust_placement(axis, adjust_placement)

    Chart.put_settings(chart, settings)
  end

  def set_axis_label(%Chart{} = chart, axis, text) do
    settings = chart.settings |> AxisLine.Label.set_text(axis, text)

    Chart.put_settings(chart, settings)
  end

  def set_axis_label_placement(%Chart{} = chart, axis, placement) do
    settings = chart.settings |> AxisLine.Label.set_placement(axis, placement)

    Chart.put_settings(chart, settings)
  end

  #  Grid setters

  def set_grid(%Chart{} = chart, axis_grid_type) do
    settings = chart.settings |> GridLine.set_grid(axis_grid_type)

    Chart.put_settings(chart, settings)
  end

  #  Title setters

  def set_title_position(%Chart{} = chart, text) do
    settings = chart.settings |> Text.set_position(:title, text)

    Chart.put_settings(chart, settings)
  end

  def set_title_text(%Chart{} = chart, text) do
    settings = chart.settings |> Text.set_text(:title, text)

    Chart.put_settings(chart, settings)
  end
end
