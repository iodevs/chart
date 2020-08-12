defmodule Chart.Internal.AxisLine.MinorTicks do
  @moduledoc false

  alias Chart.Internal.AxisLine.Helpers
  import Chart.Internal.Guards, only: [is_positive_number: 1]

  @self_key :minor_ticks

  def new() do
    %{
      count: 20,
      gap: 0,
      length: 0.25,
      positions: []
    }
  end

  def add(settings, axis) when is_map(settings) and is_atom(axis) do
    settings
    |> put_in([axis, @self_key], new())
    |> set_positions(axis)
  end

  # Setters

  def set_count(settings, axis, count)
      when is_map(settings) and is_atom(axis) and is_integer(count) and 1 < count do
    settings
    |> put_in([axis, @self_key, :count], count)
    |> set_positions(axis)
  end

  def set_gap(settings, axis, gap) when is_map(settings) and is_atom(axis) and is_number(gap) do
    put_in(settings, [axis, @self_key, :gap], gap)
  end

  def set_length(settings, axis, length)
      when is_map(settings) and is_atom(axis) and is_positive_number(length) do
    put_in(settings, [axis, @self_key, :length], length)
  end

  def set_positions(settings, axis) when is_map(settings) and is_atom(axis) do
    settings_ax = settings[axis]

    positions =
      Helpers.compute_ticks_positions(
        axis,
        settings.plot.position,
        settings.plot.size,
        settings_ax.minor_ticks.count,
        settings_ax.scale
      )

    settings
    |> put_in([axis, @self_key, :positions], positions)
  end
end
