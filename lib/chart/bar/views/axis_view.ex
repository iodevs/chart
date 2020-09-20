defmodule Chart.Bar.Views.AxisView do
  @moduledoc false

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

  def css_id_axis_ticks_line(axis, tick_type) do
    "#{Atom.to_string(axis)}-#{convert_tick_type(tick_type)}-line"
  end

  def css_class_axis_ticks(axis, tick_type) do
    "#{Atom.to_string(axis)}-#{convert_tick_type(tick_type)}"
  end

  def css_class_axis_major_ticks_label(axis) do
    "#{Atom.to_string(axis)}-major-ticks-label"
  end

  def css_class_axis_tick_label(axis) do
    "#{Atom.to_string(axis)}-tick-label"
  end

  def css_id_axis_label(axis) do
    "#{Atom.to_string(axis)}-label"
  end

  def set_axis_line(line, thickness, {1, 0}) do
    Tuple.append(line, thickness)
  end

  def set_axis_line({x1, y1, x2, y2}, thickness, {0, 1}) do
    {x1, y1, x2, y2 + thickness / 2, thickness}
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

  # Private

  defp convert_tick_type(tp) when is_atom(tp) do
    tp |> Atom.to_string() |> String.replace("_", "-")
  end
end
