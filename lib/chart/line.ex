defmodule Chart.Line do
  @moduledoc """
  A line chart definition structure
  """

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
end
