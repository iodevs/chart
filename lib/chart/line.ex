defmodule Chart.Line do
  @moduledoc """
  A line chart definition structure
  """

  alias Chart.Chart
  alias Chart.Line.{Settings, Svg}

  def put(%Chart{} = chart, data) do
    Chart.put_data(chart, data)
  end

  def render(%Chart{} = chart) do
    chart |> Svg.generate()
  end

  def setup() do
    Chart.new()
    |> Chart.put_settings(Settings.new())
  end
end
