defmodule Chart.Line.Settings do
  @moduledoc """
  A line chart settings.
  """

  alias Chart.Internal.AxisLine.{Label, MajorTicks, MajorTicksText, MinorTicks}
  alias Chart.Internal.{AxisLine, Figure, GridLine, Plot, Title}

  def new() do
    %{}
    |> Figure.add()
    |> Title.add()
    |> Title.set_text("Graph")
    |> Title.set_position({400, 50})
    |> Plot.add()
    |> GridLine.add()
    |> axis(:x_axis)
    |> axis(:y_axis)
    |> Label.set_text(:x_axis, "Axis X")
    |> MajorTicksText.set_range(:x_axis, {0, 10})
    # |> AxisLine.set_scale(:x_axis, :log)
    |> Label.set_text(:y_axis, "Axis Y")
    |> MinorTicks.set_count(:y_axis, 3)
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
