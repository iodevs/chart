defmodule Chart.Internal.AxisLine do
  @moduledoc false

  alias Chart.Internal.AxisLine.{MajorTicks, MinorTicks, MajorTicksText}

  defguard scale(s) when s in [:linear, :log]

  def new() do
    %{
      line: nil,
      scale: :linear,
      thickness: 2,
      vector: {0, 0}
    }
  end

  def add(settings, axis, vector) when is_map(settings) and is_atom(axis) do
    settings
    |> Map.put(axis, new())
    |> put_in([axis, :vector], vector)
    |> set_line(axis)
  end

  # Setters

  def set_line(%{axis_table: axis_table} = settings, axis)
      when is_map(settings) and is_map_key(axis_table, axis) do
    line = compute_line(settings[axis].vector, settings.plot.position, settings.plot.size)

    put_in(settings, [axis, :line], line)
  end

  @doc """
  scale :: :linear | :log
  """
  def set_scale(%{axis_table: axis_table} = settings, axis, scale)
      when is_map(settings) and is_map_key(axis_table, axis) and scale(scale) do
    settings
    |> put_in([axis, :scale], scale)
    |> MajorTicks.set_positions(axis)
    |> MinorTicks.set_positions(axis)
    |> MajorTicksText.set_positions(axis)
    |> MajorTicksText.set_labels(axis)
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
