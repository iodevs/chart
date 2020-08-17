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
    {axis, _map} =
      map
      |> Enum.find(fn
        {_axis, %{vector: v}} -> v == vector
        {_k, _v} -> nil
      end)

    axis
  end

  # Math

  @doc """
  Linear transform function.

  transform(point, parametr, vector)
  """
  @spec transform({number(), number()}, number(), {number(), number()}) :: {number(), number()}
  def transform({px, py}, parameter, {vx, vy}) do
    {px + parameter * vx, py + parameter * vy}
  end

  @doc """
  Generate linearly spaced list.

  y = linspace(x1, x2) returns a list of 10 evenly spaced points between x1 and x2.
  y = linspace(x1, x2, N) generates N points between x1 and x2.
  """
  @spec linspace({number(), number()}, pos_integer()) :: list(number())
  def linspace({min, max}, num_points), do: linspace(min, max, num_points)

  @spec linspace(number(), number(), pos_integer()) :: list(number())
  def linspace(min, max, num_points \\ 10)
      when is_number(min) and is_number(max) and is_integer(num_points) and min < max and
             1 < num_points do
    delta = :erlang.abs(max - min) / (num_points - 1)

    Enum.map(0..(num_points - 1), fn i -> min + i * delta end)
  end

  @doc """
  Return numbers spaced evenly on a log scale. It means that generates `N` points between
  decades `10^min` and `10^max`.
  """
  @spec logspace({number(), number()}, pos_integer()) :: list(number())
  def logspace({min, max}, num_points), do: logspace(min, max, num_points)

  @spec logspace(number(), number(), pos_integer()) :: list(number())
  def logspace(min, max, num_points)
      when is_number(min) and is_number(max) and is_integer(num_points) and min < max and
             1 < num_points do
    linspace(min, max, num_points) |> Enum.map(&:math.pow(10, &1))
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
