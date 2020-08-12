defmodule Chart.Internal.AxisLine do
  @moduledoc false

  alias Chart.Internal.AxisLine.Helpers

  defguard scale(s) when s in [:linear, :log]

  def new() do
    %{
      scale: :linear,
      thickness: 2,
      line: nil
    }
  end

  def add(settings, key) when is_map(settings) and is_atom(key) do
    settings
    |> put_in([:plot, :axis], [key | settings.plot.axis])
    |> Map.put(key, new())
  end

  # Setters

  @doc """
  scale :: :linear | :log
  """
  def set_scale(settings, axis, scale) when is_map(settings) and is_atom(axis) and scale(scale) do
    settings
    |> put_in([axis, :scale], scale)
    |> Helpers.recalculate_ticks_positions(axis)
    |> Helpers.recalculate_ticks_labels(axis)
  end

  @doc """
  thickness :: 0 < number
  """
  def set_thickness(settings, axis, thickness)
      when is_map(settings) and is_atom(axis) and is_number(thickness) and thickness > 0 do
    settings
    |> put_in([axis, :thickness], thickness)
    |> Helpers.recalculate_line(axis)
  end
end
