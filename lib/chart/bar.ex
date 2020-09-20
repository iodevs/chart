defmodule Chart.Bar do
  @moduledoc """
  A bar chart definition structure
  """

  alias Chart.Internal.AxisLine
  alias Chart.Internal
  alias Chart.Line.{Settings, Svg}
  alias Chart.Chart

  def put(%Chart{} = chart, data) do
    chart |> Chart.put_data(data)
  end

  def render(%Chart{} = chart) do
    chart |> Svg.generate()
  end

  def setup() do
    Internal.Storage.Buffer
    |> Chart.new()
    |> Chart.put_settings(Settings.new())
    |> Chart.register([
      &AxisLine.MajorTicksText.recalc_range/1
    ])
  end
end
