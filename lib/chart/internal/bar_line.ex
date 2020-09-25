defmodule Chart.Internal.BarLine do
  @moduledoc false

  import Chart.Internal.Guards, only: [is_positive_number: 1]

  @x_axis :x_axis

  def new() do
    %{
      line: nil,
      thickness: 2,
      vector: {1, 0}
    }
  end

  def add(settings) when is_map(settings) do
    settings
    |> Map.put(@x_axis, new())
    |> set_line()
  end

  # Setters

  def set_line(%{axis_table: axis_table} = settings, axis \\ @x_axis)
      when is_map(settings) and is_map_key(axis_table, axis) do
    line = compute_line(settings[axis].vector, settings.plot.position, settings.plot.size)

    put_in(settings, [axis, :line], line)
  end

  @doc """
  thickness :: 0 < number
  """
  def set_thickness(%{axis_table: axis_table} = settings, axis, thickness)
      when is_map(settings) and is_map_key(axis_table, axis) and
             is_number(thickness) and 0 < thickness do
    put_in(settings, [axis, :thickness], thickness)
  end

  # Private

  defp compute_line({1, 0}, {pos_x, pos_y}, {width, height}) do
    {pos_x, pos_y + height, pos_x + width, pos_y + height}
  end

  defp compute_line({0, 1}, {pos_x, pos_y}, {_width, height}) do
    {pos_x, pos_y, pos_x, pos_y + height}
  end
end
