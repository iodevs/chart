defmodule Chart.TimeLine do
  @moduledoc """
  A timeline chart definition structure
  """

  alias Chart.Internal.AxisLine
  alias Chart.Internal.Storage.Queue
  alias Chart.Line
  alias Chart.Chart

  defdelegate put(chart, data), to: Line
  defdelegate render(chart), to: Line
  defdelegate set_viewbox(chart, viewbox), to: Line
  defdelegate set_aspect_ratio(chart, aspect_ratio), to: Line
  defdelegate set_thickness(chart, axis, thickness), to: Line
  defdelegate set_axis_label_adjust_placement(chart, axis, adjust_placement), to: Line
  defdelegate set_axis_label(chart, axis, text), to: Line
  defdelegate set_axis_label_placement(chart, axis, placement), to: Line
  defdelegate add_axis_minor_ticks(chart, axis), to: Line
  defdelegate set_axis_minor_ticks_count(chart, axis, count), to: Line
  defdelegate set_axis_minor_ticks_gap(chart, axis, gap), to: Line
  defdelegate set_axis_minor_ticks_length(chart, axis, length), to: Line
  defdelegate set_axis_major_ticks_count(chart, axis, count), to: Line
  defdelegate set_axis_major_ticks_gap(chart, axis, gap), to: Line
  defdelegate set_axis_major_ticks_length(chart, axis, length), to: Line
  defdelegate set_axis_ticks_text_format(chart, axis, format), to: Line
  defdelegate set_axis_ticks_text_gap(chart, axis, gap), to: Line
  defdelegate set_axis_ticks_text_range_offset(chart, axis, range_offset), to: Line
  defdelegate set_grid(chart, axis_grid_type), to: Line
  defdelegate set_grid_gap(chart, axis_grid_type, number), to: Line
  defdelegate set_plot_background_padding(chart, padding), to: Line
  defdelegate set_plot_position(chart, position), to: Line
  defdelegate set_plot_size(chart, size), to: Line
  defdelegate set_title_position(chart, position), to: Line
  defdelegate set_title_text(chart, text), to: Line
  defdelegate set_count_data(chart, count), to: Queue, as: :set_count

  def setup() do
    Queue
    |> Chart.new()
    |> Chart.put_settings(Line.Settings.new())
    |> Chart.register([
      &AxisLine.MajorTicksText.recalc_range/1
    ])
  end
end
