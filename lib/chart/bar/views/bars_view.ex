defmodule Chart.Bar.Views.BarsView do
  @moduledoc false

  def calc_rect_attributes(values, positions, {from, to}, {_x1, y1, _x2, y2}, bar_width) do
    bw_half = bar_width / 2

    positions
    |> Enum.zip(values)
    |> Enum.map(fn {px, val} ->
      val = transform(val, {from, to, y2, y1})

      {px - bw_half, val, bar_width, y2 - val}
    end)
  end

  # Private

  defp transform(x, {from, to, ax_start, ax_end}) do
    {x, {from, to, ax_start, ax_end}}

    (ax_end - ax_start) / (to - from) * (x - from) + ax_start
  end
end
