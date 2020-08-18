defmodule Chart.Line.View do
  @moduledoc false

  alias Chart.Internal.Utils

  @gap_from_x_axis_line 30
  @gap_from_y_axis_line 35

  def axis_ticks_label({_x1, y1, _x2, _y2}, major_ticks_text, {1, 0}) do
    pos_y =
      List.duplicate(
        y1 + @gap_from_x_axis_line + major_ticks_text.gap,
        length(major_ticks_text.positions)
      )

    List.zip([major_ticks_text.positions, pos_y, major_ticks_text.labels])
  end

  def axis_ticks_label({x1, _y1, _x2, _y2}, major_ticks_text, {0, 1}) do
    pos_x =
      List.duplicate(
        x1 - @gap_from_y_axis_line + major_ticks_text.gap,
        length(major_ticks_text.positions)
      )

    List.zip([pos_x, major_ticks_text.positions |> Enum.reverse(), major_ticks_text.labels])
  end

  def get_axis(settings, vector) do
    Utils.get_axis_for_vector(settings.axis_table, vector)
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

  def set_axis_tick(length, {1, 0}) do
    {0, length}
  end

  def set_axis_tick(length, {0, 1}) do
    {length, 0}
  end

  def translate_axis_ticks({_x1, y1, _x2, _y2}, _length, gap, px, {1, 0}) do
    "translate(#{px}, #{y1 + gap})"
  end

  def translate_axis_ticks({x1, _y1, _x2, _y2}, length, gap, py, {0, 1}) do
    "translate(#{x1 - length + gap}, #{py})"
  end
end
