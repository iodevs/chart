defmodule Chart.SomeChart do
  @moduledoc """
  An example chart.
  """

  alias Chart.SomeChart.Settings
  alias Chart.Chart

  def new() do
    Chart.new()
    |> Chart.put_settings(Settings.new())
  end
end
