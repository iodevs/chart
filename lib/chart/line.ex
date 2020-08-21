defmodule Chart.Line do
  @moduledoc """
  A line chart definition structure
  """

  alias Chart.Line.{Buffer, Settings, Svg}
  alias Chart.Chart

  def put(%Chart{} = chart, data) do
    chart
    |> Buffer.process(data)
    |> Chart.put_data(data)
  end

  def render(%Chart{} = chart) do
    chart |> Svg.generate()
  end

  def setup() do
    Chart.new()
    |> Chart.put_settings(Settings.new())
  end
end
