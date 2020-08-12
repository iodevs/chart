defmodule Chart.SomeChart.Settings do
  @moduledoc """
  A chart settings.
  """

  alias Chart.Internal.AxisLine.{Helpers, Label, MajorTicks, MajorTicksText, MinorTicks}
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
    |> AxisLine.add(key)
    |> Label.add(key)
    |> MajorTicks.add(key)
    |> MajorTicksText.add(key)
    |> MinorTicks.add(key)
    |> Helpers.recalculate_ticks_positions(key)
    |> Helpers.recalculate_line(key)
    |> Helpers.recalculate_label_position(key)
    |> Helpers.recalculate_ticks_labels(key)
  end
end
