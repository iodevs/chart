defmodule Chart.Line.Settings do
  @moduledoc """
  A line chart settings.
  """

  alias Chart.Internal.AxisLine.{Label, MajorTicks, MajorTicksText, MinorTicks}
  alias Chart.Internal.{AxisLine, Figure, GridLine, Plot, Text}

  def new() do
    %{axis_table: %{}, marker: nil, shape: :linear}
    |> Figure.add()
    |> Text.add(:title)
    |> Text.set_text(:title, "Graph")
    |> Text.set_position(:title, {400, 50})
    |> Plot.add()
    |> GridLine.add()
    |> axis(:x_axis, {1, 0})
    |> axis(:y_axis, {0, 1})
    |> MajorTicksText.set_range(:x_axis, {0, 10})
    |> MajorTicksText.set_range_offset(:y_axis, :auto)
    # |> MajorTicksText.set_range_offset(:x_axis, :auto)
    |> Label.set_text(:x_axis, "Axis X")
    # |> AxisLine.set_scale(:x_axis, :log)
    |> Label.set_text(:y_axis, "Axis Y")
    # |> Label.set_adjust_placement(:y_axis, {0, -30})
    |> MinorTicks.add(:x_axis)
    |> MinorTicks.add(:y_axis)
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
  end
end
