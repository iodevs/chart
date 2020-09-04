defmodule Chart.Line.Buffer do
  @moduledoc false

  alias Chart.Internal.AxisLine.MajorTicksText
  alias Chart.Chart

  def put(%Chart{data: buffer, settings: %{storage_count: count}} = chart, data) do
    merged_data = merge(buffer, data, count)
    fl_data = List.flatten(merged_data)

    range_for_x = fl_data |> get_axis_range({1, 0}) |> add_offset_to_range()
    range_for_y = fl_data |> get_axis_range({0, 1}) |> add_offset_to_range()

    updated_settings =
      chart.settings
      |> MajorTicksText.set_range({1, 0}, range_for_x)
      |> MajorTicksText.set_range({0, 1}, range_for_y)

    chart
    |> Chart.put_settings(updated_settings)
    |> Chart.put_data(merged_data)
  end

  def set_count(settings, count) when is_integer(count) and 0 < count do
    Map.put(settings, :storage_count, count)
  end

  # Private

  defp merge(nil, data, _count) do
    data
  end

  defp merge([first | _rest] = buffer, data, count) when length(first) <= count do
    buffer
    |> Enum.zip(data)
    |> Enum.map(fn {bf, d} -> Enum.concat(bf, d) end)
  end

  defp merge(buffer, data, count) do
    buffer
    |> Enum.map(fn [_first | rest] -> rest end)
    |> merge(data, count)
  end

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
