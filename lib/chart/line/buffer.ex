defmodule Chart.Line.Buffer do
  @moduledoc false

  alias Chart.Internal.AxisLine.MajorTicksText
  alias Chart.Chart

  def process(%Chart{} = chart, data) do
    data = List.flatten(data)
    range_for_x = data |> get_axis_range({1, 0}) |> add_offset_to_range()
    range_for_y = data |> get_axis_range({0, 1}) |> add_offset_to_range()

    updated_settings =
      chart.settings
      |> MajorTicksText.set_range({1, 0}, range_for_x)
      |> MajorTicksText.set_range({0, 1}, range_for_y)

    Chart.put_settings(chart, updated_settings)
  end

  # Private

  defp get_axis_range(data, {1, 0}) do
    {{min_x, _y1}, {max_x, _y2}} = Enum.min_max_by(data, fn {x, _y} -> x end)

    {min_x, max_x}
  end

  defp get_axis_range(data, {0, 1}) do
    {{_x1, min_y}, {_x2, max_y}} = Enum.min_max_by(data, fn {_x, y} -> y end)

    {min_y, max_y}
  end

  defp add_offset_to_range({min, max}) when 0 < min do
    {0, max + offset(max)}
  end

  defp add_offset_to_range({min, max}) do
    {min, max + offset(max)}
  end

  defp offset(max) do
    log10 = :math.log10(max)

    exp =
      if log10 < 1 do
        Float.floor(log10)
      else
        Float.floor(log10) - 1
      end

    :math.pow(10, exp)
  end
end
