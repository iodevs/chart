defmodule Chart.Bar.Settings do
  @moduledoc """
  A line chart settings.
  """

  alias Chart.Internal.AxisLine.{Label, MajorTicks, MajorTicksText}
  alias Chart.Internal.{AxisLine, Figure, GridLine, Plot, Text}
  @type type_bar :: :normal | :stacked | :grouped
  @type orientation :: :horizontal | :vertical

  def new() do
    %{axis_table: %{}, type: :normal, orientation: :horizontal}
    |> Figure.add()
    |> Plot.add()
    |> GridLine.add()
    |> axis(:x_axis, {1, 0})
    |> axis(:y_axis, {0, 1})
    |> MajorTicksText.set_range(:x_axis, {0, 10})
    |> MajorTicksText.set_range_offset(:y_axis, :auto)
    |> Label.set_placement(:y_axis, :middle)
    |> Text.add(:title)
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
