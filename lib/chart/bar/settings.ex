defmodule Chart.Bar.Settings do
  @moduledoc """
  A line chart settings.
  """

  alias Chart.Internal.AxisLine.{Label, MajorTicks, MajorTicksText}
  alias Chart.Internal.{AxisLine, Figure, GridLine, Plot, Text}
  import Chart.Internal.Guards, only: [is_nonnegative_number: 1, is_positive_number: 1]

  @type type_bar :: :normal | :stacked | :grouped
  @type orientation :: :horizontal | :vertical

  def new() do
    %{
      axis_table: %{},
      bar: %{
        gap: 0,
        orientation: :vertical,
        type: :normal,
        width: :auto
      }
    }
    |> Figure.add()
    |> Plot.add()
    |> GridLine.add()
    |> axis(:x_axis, {1, 0})
    |> axis(:y_axis, {0, 1})
    |> Label.add(:y_axis)
    |> Label.set_placement(:y_axis, :top)
    |> Label.set_adjust_placement(:y_axis, {10, -25})
    |> Text.add(:title)
    |> set_gap(0.500)
  end

  def axis(settings, key, vector)
      when is_map(settings) and is_atom(key) and is_tuple(vector) do
    settings
    |> put_in([:axis_table], Map.put_new(settings.axis_table, key, vector))
    |> AxisLine.add(key, vector)
    |> MajorTicks.add(key)
    |> MajorTicksText.add(key)
  end

  def set_gap(settings, gap) when is_map(settings) and is_nonnegative_number(gap) do
    put_in(settings, [:bar, :gap], gap)
  end

  def set_width(settings, width)
      when is_map(settings) and is_positive_number(width) do
    put_in(settings, [:bar, :width], width)
  end
end
