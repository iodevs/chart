defmodule Chart.Line do
  @moduledoc """
  A line chart definition structure
  """

  alias Chart.Internal.{GridLine, Text}
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

  #  Setters

  def set_grid(%Chart{} = chart, axis_grid_type) do
    settings = chart.settings |> GridLine.set_grid(axis_grid_type)

    Chart.put_settings(chart, settings)
  end

  def set_title_position(%Chart{} = chart, text) do
    settings = chart.settings |> Text.set_position(:title, text)

    Chart.put_settings(chart, settings)
  end

  def set_title_text(%Chart{} = chart, text) do
    settings = chart.settings |> Text.set_text(:title, text)

    Chart.put_settings(chart, settings)
  end
end
