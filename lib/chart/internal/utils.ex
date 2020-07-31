defmodule Chart.Internal.Utils do
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

  # Math

  def linspace({min, max}, step), do: linspace(min, max, step)

  def linspace(min, max, step) do
    delta = :erlang.abs(max - min) / (step - 1)

    Enum.reduce(1..(step - 1), [min], fn x, acc ->
      acc ++ [x * delta]
    end)
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
end
