defmodule Chart.Internal.Utils do
  @moduledoc false

  alias ExMaybe, as: Maybe

  def update_module(settings, kw, validate) do
    settings
    |> Map.from_struct()
    |> Enum.reduce(settings, &update(&1, &2, kw, validate))
  end

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

  @spec linspace(number(), number(), pos_integer()) :: list(number())
  def linspace(min, max, step)
      when is_number(min) and is_number(max) and is_integer(step) and min < max and 1 < step do
    delta = :erlang.abs(max - min) / (step - 1)

    Enum.reduce(1..(step - 1), [min], fn x, acc ->
      acc ++ [min + x * delta]
    end)
  end

  @doc """
  Return numbers spaced evenly on a log scale. It means that generates `n` points between
  decades `10^min` and `10^max`.
  """
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

  #  Others

  defp update({key, value}, acc, config, validate) do
    {config_key, f} = Map.get(validate, key, {key, fn val -> val end})

    value =
      config
      |> Keyword.get(config_key)
      |> Maybe.map(f)
      |> Maybe.with_default(value)

    Map.put(acc, key, value)
  end
end
