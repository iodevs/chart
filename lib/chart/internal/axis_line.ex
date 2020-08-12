defmodule Chart.Internal.AxisLine do
  @moduledoc false

  alias Chart.Internal.AxisLine.{MajorTicks, MinorTicks, MajorTicksText}

  defguard scale(s) when s in [:linear, :log]

  def new() do
    %{
      line: nil,
      scale: :linear,
      thickness: 2
    }
  end

  def add(settings, axis) when is_map(settings) and is_atom(axis) do
    settings
    |> Map.put(axis, new())
    |> set_line(axis)
  end

  # Setters

  def set_line(settings, axis) when is_map(settings) and is_atom(axis) do
    line =
      compute_line(axis, settings.plot.position, settings.plot.size, settings[axis].thickness)

    put_in(settings, [axis, :line], line)
  end

  @doc """
  scale :: :linear | :log
  """
  def set_scale(settings, axis, scale) when is_map(settings) and is_atom(axis) and scale(scale) do
    settings
    |> put_in([axis, :scale], scale)
    |> MajorTicks.set_positions(axis)
    |> MinorTicks.set_positions(axis)
    |> MajorTicksText.set_labels(axis)
  end

  @doc """
  thickness :: 0 < number
  """
  def set_thickness(settings, axis, thickness)
      when is_map(settings) and is_atom(axis) and is_number(thickness) and thickness > 0 do
    settings
    |> put_in([axis, :thickness], thickness)
    |> set_line(axis)
  end

  # Private

  defp compute_line(:x_axis, {pos_x, pos_y}, {width, height}, thickness) do
    {pos_x, pos_y + height, pos_x + width, pos_y + height, thickness}
  end

  defp compute_line(:y_axis, {pos_x, pos_y}, {_width, height}, thickness) do
    {pos_x, pos_y, pos_x, pos_y + height + thickness / 2, thickness}
  end
end
