defmodule Chart.Line.AxisView do
  @moduledoc false

  def css_id_axis_major_line_ticks(axis) do
    "#{Atom.to_string(axis)}-major-line-ticks"
  end

  def css_id_axis_minor_line_ticks(axis) do
    "#{Atom.to_string(axis)}-minor-line-ticks"
  end

  def css_class_axis_major_ticks(axis) do
    "#{Atom.to_string(axis)}-major-ticks"
  end

  def css_class_axis_minor_ticks(axis) do
    "#{Atom.to_string(axis)}-minor-ticks"
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

  def set_axis_tick(length, {1, 0}) do
    {0, length}
  end

  def set_axis_tick(length, {0, 1}) do
    {length, 0}
  end
end
