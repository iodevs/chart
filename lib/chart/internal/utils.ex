defmodule Chart.Internal.Utils do
  @moduledoc false

  def datetime_format(int, dt) when is_integer(int) and is_binary(dt) do
    int
    |> DateTime.from_unix!()
    # |> DateTime.from_unix!(:millisecond)
    # |> DateTime.to_naive()
    |> NimbleStrftime.format(dt)
  end

  def datetime_format(num, dt) when is_float(num) and is_binary(dt) do
    num
    |> round_value(0)
    |> List.to_integer()
    |> DateTime.from_unix!()
    |> NimbleStrftime.format(dt)
  end

  def find_axis_for_vector(map, vector) do
    for {axis, %{vector: ^vector}} <- map, do: axis
  end

  # Math

  @doc """
  transform(point, parametr, vector)
  """
  def transform({px, py}, parameter, {vx, vy}) do
    {px + parameter * vx, py + parameter * vy}
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

  def log10({a, b}) do
    {:math.log10(a), :math.log10(b)}
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
