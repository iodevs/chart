defmodule Chart.SomeChart do
  @moduledoc """
  An example chart.
  """

  alias Chart.Line.Settings
  alias Chart.Line

  def new() do
    Line.new()
    |> Line.put_settings(Settings.new())
  end
end
