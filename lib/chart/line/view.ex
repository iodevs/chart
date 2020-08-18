defmodule Chart.Line.View do
  @moduledoc false

  alias Chart.Internal.Utils

  @gap_from_x_axis_line 30
  @gap_from_y_axis_line 35

  def get_axis(settings, vector) do
    Utils.find_axis_for_vector(settings, vector)
  end

  def parse_chart(settings) do
    {settings.figure, settings.grid, settings.plot, settings.title}
  end

  def plot_rect_bg(plot) do
    {px, py} = plot.position
    {width, height} = plot.size
    {top, right, bottom, left} = plot.rect_bg_padding

    {px - left, py - top, width + left + right, height + top + bottom}
  end

  def set_axis_line(settings_ax, {1, 0}) do
    Tuple.append(settings_ax.line, settings_ax.thickness)
  end

  def set_axis_line(settings_ax, {0, 1}) do
    {x1, y1, x2, y2} = settings_ax.line

    {x1, y1, x2, y2 + settings_ax.thickness / 2, settings_ax.thickness}
  end

  def translate_x_ticks({_x1, y1, _x2, _y2}, gap, px) do
    "translate(#{px}, #{y1 + gap})"
  end

  def translate_y_ticks({x1, _y1, _x2, _y2}, length, gap, py) do
    "translate(#{x1 - length + gap}, #{py})"
  end

  def x_ticks_label({_x1, y1, _x2, _y2}, major_ticks_text) do
    pos_y =
      List.duplicate(
        y1 + @gap_from_x_axis_line + major_ticks_text.gap,
        length(major_ticks_text.positions)
      )

    List.zip([major_ticks_text.positions, pos_y, major_ticks_text.labels])
  end

  def y_ticks_label({x1, _y1, _x2, _y2}, major_ticks_text) do
    pos_x =
      List.duplicate(
        x1 - @gap_from_y_axis_line + major_ticks_text.gap,
        length(major_ticks_text.positions)
      )

    List.zip([pos_x, major_ticks_text.positions |> Enum.reverse(), major_ticks_text.labels])
  end
end
