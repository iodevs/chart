defmodule Chart.SomeChart.Settings do
  @moduledoc """
  A chart settings.
  """

  alias Chart.Internal.AxisLine.{Label, MajorTicks, MajorTicksText, MinorTicks}
  alias Chart.Internal.{AxisLine, Figure, GridLine, Plot, Title}

  def new() do
    %{}
    |> Figure.add()
    |> Title.add()
    |> Title.set_text("Graph")
    |> Plot.add()
    |> GridLine.add()
    |> axis(:x_axis)
    |> axis(:y_axis)
    |> Label.set_text(:x_axis, "Axis X")
    |> Label.set_text(:y_axis, "Axis Y")
    |> Label.set_placement(:y_axis, :top)
  end

  def axis(settings, key) when is_map(settings) and is_atom(key) do
    settings
    |> set_axis(key)
    |> Label.add(key)
    |> MajorTicks.add(key)
    |> MajorTicksText.add(key)
    |> MinorTicks.add(key)
  end

  # Private

  defp set_axis(settings, :x_axis) do
    AxisLine.add(settings, :x_axis, {1, 0})
  end

  defp set_axis(settings, :y_axis) do
    AxisLine.add(settings, :y_axis, {0, 1})
  end
end
