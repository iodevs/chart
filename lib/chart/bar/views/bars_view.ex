defmodule Chart.Bar.Views.BarsView do
  @moduledoc false

  def calc_rect_attributes(values, positions, major_ticks_text, line, bar_width) do
    positions
    |> Enum.zip(values)
    |> Enum.map(&transform_val(&1, major_ticks_text, line, bar_width))
  end

  # Private

  defp transform_val(
         {px, val},
         %{range: range, limit_range: :auto},
         {_x1, y1, _x2, y2},
         bar_width
       ) do
    val = transform(val, range, {y2, y1})

    {px - bar_width / 2, val, bar_width, y2 - val}
  end

  defp transform_val(
         {px, val},
         %{range: {min, max}, limit_range: :fixed},
         {_x1, y1, _x2, y2},
         bar_width
       ) do
    val =
      if val <= max do
        transform(val, {min, max, y2, y1})
      else
        transform(max, {min, max, y2, y1})
      end

    {px - bar_width / 2, val, bar_width, y2 - val}
  end

  defp transform(x, {from, to}, {ax_start, ax_end}) do
    transform(x, {from, to, ax_start, ax_end})
  end

  defp transform(x, {from, to, ax_start, ax_end}) do
    (ax_end - ax_start) / (to - from) * (x - from) + ax_start
  end
end
