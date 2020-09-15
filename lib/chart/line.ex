defmodule Chart.Line do
  @moduledoc """
  A line chart definition structure
  """

  alias Chart.Line.{Settings, Svg}
  alias Chart.Chart

  def put(%Chart{settings: %{storage: storage}} = chart, data) do
    chart
    |> storage.type.put(data)
  end

  def render(%Chart{} = chart) do
    chart |> Svg.generate()
  end

  def setup() do
    Chart.new()
    |> Chart.put_settings(Settings.new())
  end
end
