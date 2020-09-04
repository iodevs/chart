defmodule Chart.Line.Settings do
  @moduledoc """
  A line chart settings.
  """

  alias Chart.Internal.AxisLine.{Label, MajorTicks, MajorTicksText, MinorTicks}
  alias Chart.Internal.{AxisLine, Figure, GridLine, Plot, Text}

  def new() do
    %{axis_table: %{}}
    |> Figure.add()
    |> Text.add(:title)
    |> Text.set_text(:title, "Graph")
    |> Text.set_position(:title, {400, 50})
    |> Plot.add()
    |> GridLine.add()
    |> GridLine.set_grid(:x_major)
    |> GridLine.set_grid(:y_major)
    |> axis(:x_axis, {1, 0})
    |> axis(:y_axis, {0, 1})
    |> Label.set_text(:x_axis, "Axis X")
    |> MajorTicksText.set_range(:x_axis, {0, 10})
    # |> AxisLine.set_scale(:x_axis, :log)
    |> Label.set_text(:y_axis, "Axis Y")
    # |> Label.set_adjust_placement(:y_axis, {0, -30})
    |> MinorTicks.set_count(:y_axis, 3)
    |> Label.set_placement(:y_axis, :middle)
  end

  def axis(settings, key, vector)
      when is_map(settings) and is_atom(key) and is_tuple(vector) do
    settings
    |> put_in([:axis_table], Map.put_new(settings.axis_table, key, vector))
    |> AxisLine.add(key, vector)
    |> Label.add(key)
    |> MajorTicks.add(key)
    |> MajorTicksText.add(key)
    |> MinorTicks.add(key)
  end
end
