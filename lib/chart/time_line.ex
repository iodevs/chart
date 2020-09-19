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
  defdelegate set_title_text(settings, text), to: Line
  defdelegate set_title_position(settings, position), to: Line
  defdelegate set_grid(settings, type_grid), to: Line
  defdelegate set_axis_label(settings, axis, text), to: Line
  defdelegate set_axis_major_ticks_count(settings, axis, count), to: Line
  defdelegate set_axis_ticks_text_format(settings, axis, format), to: Line
  defdelegate add_axis_minor_ticks(settings, axis), to: Line
  defdelegate set_axis_minor_ticks_count(settings, axis, count), to: Line

  def setup() do
    Queue
    |> Chart.new()
    |> Chart.put_settings(Line.Settings.new())
    |> Chart.register([
      &AxisLine.MajorTicksText.recalc_range/1
    ])
  end

  def set_count_data(%Chart{} = chart, count) do
    Queue.set_count(chart, count)
  end
end
