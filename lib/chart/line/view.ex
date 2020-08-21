defmodule Chart.Line.View do
  @moduledoc false

  alias Chart.Internal.Utils

  def plot_rect_bg(plot) do
    {px, py} = plot.position
    {width, height} = plot.size
    {top, right, bottom, left} = plot.rect_bg_padding

    {px - left, py - top, width + left + right, height + top + bottom}
  end

  def set_line_points(settings, data) do
    x_axis = Utils.get_axis_for_vector(settings.axis_table, {1, 0})
    y_axis = Utils.get_axis_for_vector(settings.axis_table, {0, 1})

    data
    |> Enum.map(fn {x, y} ->
      [
        transform(x, get_intervals(settings[x_axis], {1, 0})),
        transform(y, get_intervals(settings[y_axis], {0, 1}))
      ]
    end)
    |> List.flatten()
    |> Enum.join(",")
  end

  # Private

  defp get_intervals(axis, {1, 0}) do
    {x1, _y1, x2, _y2} = axis.line

    axis.major_ticks_text.range
    |> Tuple.append(x1)
    |> Tuple.append(x2)
  end

  defp get_intervals(axis, {0, 1}) do
    {_x1, y1, _x2, y2} = axis.line

    axis.major_ticks_text.range
    |> Tuple.append(y2)
    |> Tuple.append(y1)
  end

  defp transform(x, {from, to, ax_start, ax_end}) do
    (ax_end - ax_start) / (to - from) * (x - from) + ax_start
  end
end
