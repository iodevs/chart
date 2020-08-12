defmodule Chart.Gauge.Utils do
  @moduledoc false

  def key_guard(kw, key, default_val, fun) do
    fun.(Keyword.get(kw, key, default_val))
  end

  def key_guard(kw, key, default_val, boundary_tpl_vals, fun) do
    fun.(Keyword.get(kw, key, default_val), boundary_tpl_vals)
  end

  def set_map(keywords, map) do
    Enum.reduce(keywords, map, fn {key, val}, map -> Map.put(map, key, val) end)
  end

  def linspace({min, max}, step), do: linspace(min, max, step)

  @spec linspace(number(), number(), pos_integer()) :: list(number())
  def linspace(min, max, step)
      when is_number(min) and is_number(max) and is_integer(step) and min < max and 1 < step do
    delta = :erlang.abs(max - min) / (step - 1)

    Enum.reduce(1..(step - 1), [min], fn x, acc ->
      acc ++ [min + x * delta]
    end)
  end

  def logspace({min, max}, step), do: logspace(min, max, step)

  @spec logspace(number(), number(), pos_integer()) :: list(number())
  def logspace(min, max, step)
      when is_number(min) and is_number(max) and is_integer(step) and min < max and 1 < step do
    linspace(min, max, step) |> Enum.map(&:math.pow(10, &1))
  end

  def round_value(value, decimals) do
    :erlang.float_to_list(1.0 * value, decimals: decimals)
  end

  def value_to_angle(val, {a, b}), do: value_to_angle(val, a, b)

  def value_to_angle(val, a, b) do
    :math.pi() - (val - a) * :math.pi() / :erlang.abs(b - a)
  end

  def polar_to_cartesian(radius, phi) do
    {radius * :math.cos(phi), radius * :math.sin(phi)}
  end

  def radian_to_degree(rad) do
    rad * 180 / :math.pi()
  end

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
