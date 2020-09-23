defmodule Chart.Bar do
  @moduledoc """
  A bar chart definition structure
  """

  alias Chart.Internal.{AxisLine, GridLine, Plot, Text}
  alias Chart.Internal
  alias Chart.Bar.{Settings, Svg}
  alias Chart.Chart

  def put(%Chart{} = chart, data) do
    chart |> Chart.put_data(data)
  end

  def render(%Chart{} = chart) do
    chart |> Svg.generate()
  end

  def setup() do
    Internal.Storage.Tuple
    |> Chart.new()
    |> Chart.put_settings(Settings.new())
    |> Chart.register([
      &AxisLine.MajorTicksText.recalc_y_axis_range/1,
      &AxisLine.MajorTicksText.set_x_axis_labels/1,
      &AxisLine.MajorTicksText.set_x_axis_positions/1
    ])
  end

  # Line setter

  def set_scale(%Chart{} = chart, axis, scale) do
    apply_setter(chart, &AxisLine.set_scale(&1, axis, scale))
  end

  def set_thickness(%Chart{} = chart, axis, thickness) do
    apply_setter(chart, &AxisLine.set_thickness(&1, axis, thickness))
  end

  #  Axis label setters

  def set_axis_label_adjust_placement(%Chart{} = chart, axis, adjust_placement) do
    apply_setter(chart, &AxisLine.Label.set_adjust_placement(&1, axis, adjust_placement))
  end

  def set_axis_label(%Chart{} = chart, axis, text) do
    apply_setter(chart, &AxisLine.Label.set_text(&1, axis, text))
  end

  def set_axis_label_placement(%Chart{} = chart, axis, placement) do
    apply_setter(chart, &AxisLine.Label.set_placement(&1, axis, placement))
  end

  #  Axis tick setters

  def add_axis_minor_ticks(%Chart{} = chart, axis) do
    apply_setter(chart, &AxisLine.MinorTicks.add(&1, axis))
  end

  def set_axis_minor_ticks_count(%Chart{} = chart, axis, count) do
    apply_setter(chart, &AxisLine.MinorTicks.set_count(&1, axis, count))
  end

  def set_axis_minor_ticks_gap(%Chart{} = chart, axis, gap) do
    apply_setter(chart, &AxisLine.MinorTicks.set_gap(&1, axis, gap))
  end

  def set_axis_minor_ticks_length(%Chart{} = chart, axis, length) do
    apply_setter(chart, &AxisLine.MinorTicks.set_length(&1, axis, length))
  end

  def set_axis_major_ticks_count(%Chart{} = chart, axis, count) do
    apply_setter(chart, &AxisLine.MajorTicks.set_count(&1, axis, count))
  end

  def set_axis_major_ticks_gap(%Chart{} = chart, axis, gap) do
    apply_setter(chart, &AxisLine.MajorTicks.set_gap(&1, axis, gap))
  end

  def set_axis_major_ticks_length(%Chart{} = chart, axis, length) do
    apply_setter(chart, &AxisLine.MajorTicks.set_length(&1, axis, length))
  end

  #  Axis tick text setters

  def set_axis_ticks_text_format(%Chart{} = chart, axis, format) do
    apply_setter(chart, &AxisLine.MajorTicksText.set_format(&1, axis, format))
  end

  def set_axis_ticks_text_gap(%Chart{} = chart, axis, gap) do
    apply_setter(chart, &AxisLine.MajorTicksText.set_gap(&1, axis, gap))
  end

  def set_axis_ticks_text_range_offset(%Chart{} = chart, axis, range_offset) do
    apply_setter(chart, &AxisLine.MajorTicksText.set_range_offset(&1, axis, range_offset))
  end

  #  Grid setters

  def set_grid(%Chart{} = chart, axis_grid_type) do
    apply_setter(chart, &GridLine.set_grid(&1, axis_grid_type))
  end

  def set_grid_gap(%Chart{} = chart, axis_grid_type, number) do
    apply_setter(chart, &GridLine.set_gap(&1, axis_grid_type, number))
  end

  # Plot setters

  def set_plot_background_padding(%Chart{} = chart, padding) do
    apply_setter(chart, &Plot.set_background_padding(&1, padding))
  end

  def set_plot_position(%Chart{} = chart, position) do
    apply_setter(chart, &Plot.set_position(&1, position))
  end

  def set_plot_size(%Chart{} = chart, size) do
    apply_setter(chart, &Plot.set_size(&1, size))
  end

  #  Title setters

  def set_title_position(%Chart{} = chart, position) do
    apply_setter(chart, &Text.set_position(&1, :title, position))
  end

  def set_title_text(%Chart{} = chart, text) do
    apply_setter(chart, &Text.set_text(&1, :title, text))
  end

  # Private

  defp apply_setter(chart, setter) do
    Chart.put_settings(chart, setter.(chart.settings))
  end
end
