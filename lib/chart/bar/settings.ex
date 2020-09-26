defmodule Chart.Bar.Settings do
  @moduledoc """
  A line chart settings.
  """

  alias Chart.Internal.{AxisLine, BarLine, Figure, GridLine, Plot, Text}
  import Chart.Internal.Guards, only: [is_positive_number: 1]

  @type type_bar :: :normal | :stacked | :grouped
  @type orientation :: :horizontal | :vertical

  @self_key :bar
  @x_axis :x_axis
  @y_axis :y_axis

  def new() do
    %{
      axis_table: %{},
      bar: %{
        orientation: :vertical,
        type: :normal,
        width: :auto
      }
    }
    |> Figure.add()
    |> Plot.add()
    |> GridLine.add()
    |> x_axis()
    |> y_axis()
    |> Text.add(:title)

    # |> set_gap(0.500)
  end

  def x_axis(settings) when is_map(settings) do
    settings
    |> put_in([:axis_table], Map.put_new(settings.axis_table, @x_axis, {1, 0}))
    |> BarLine.add()
    |> BarLine.MajorTicks.add()
    |> BarLine.MajorTicksText.add()
  end

  def y_axis(settings) when is_map(settings) do
    settings
    |> put_in([:axis_table], Map.put_new(settings.axis_table, @y_axis, {0, 1}))
    |> AxisLine.add(@y_axis, {0, 1})
    |> AxisLine.MajorTicks.add(@y_axis)
    |> AxisLine.MajorTicksText.add(@y_axis)
    |> AxisLine.Label.add(@y_axis)
    |> AxisLine.Label.set_placement(@y_axis, :top)
    |> AxisLine.Label.set_adjust_placement(@y_axis, {10, -25})
  end

  def set_width(settings, width)
      when is_map(settings) and is_positive_number(width) do
    put_in(settings, [@self_key, :width], width)
  end

  # def set_orientation(settings, orientation)
  #     when is_map(settings) and (orientation == :horizontal or orientation == :vertical) do
  #   x_axis = settings.x_axis

  #   settings
  #   |> Map.put(:x_axis, settings.y_axis)
  #   |> Map.put(:y_axis, x_axis)
  #   |> put_in([@x_axis, :vector], {1, 0})
  #   |> put_in([@y_axis, :vector], {0, 1})
  #   |> put_in([@self_key, :orientation], orientation)
  # end
end
