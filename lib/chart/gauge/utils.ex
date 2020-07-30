defmodule Chart.Gauge.Utils do
  @moduledoc false

  def is_in_interval?(val, [a, b]) when a <= val and val <= b, do: true
  def is_in_interval?(_val, _interval), do: false

  def split_major_tick_values(lst_values, count) when 1 < count do
    lst_values
    |> Enum.split(div(count, 2))
    |> rearrange()
  end

  # Private

  defp rearrange({l, r}) when length(l) == length(r), do: [l, r]
  defp rearrange({l, [center | r]}), do: [l, [center], r]
end
