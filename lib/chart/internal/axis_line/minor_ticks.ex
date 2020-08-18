defmodule Chart.Internal.AxisLine.MinorTicks do
  @moduledoc false

  alias Chart.Internal.Utils
  import Chart.Internal.Guards, only: [is_positive_number: 1]

  @self_key :minor_ticks

  def new() do
    %{
      count: 5,
      gap: 0,
      length: 10,
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

  def set_positions(settings, vector) when is_map(settings) and is_tuple(vector) do
    axis = settings.axis_table |> Utils.get_axis_for_vector(vector)

    set_positions(settings, axis)
  end

  def set_positions(settings, axis) when is_map(settings) and is_atom(axis) do
    settings_ax = settings[axis]

    positions =
      settings_ax.major_ticks.positions
      |> Enum.chunk_every(2, 1)
      |> List.delete_at(-1)
      |> Enum.map(
        &(compute_ticks_positions(
            &1,
            settings_ax.minor_ticks.count + 2,
            settings_ax.scale
          )
          |> List.delete_at(0)
          |> List.delete_at(-1))
      )
      |> List.flatten()
      |> Enum.uniq()

    put_in(settings, [axis, @self_key, :positions], positions)
  end

  # Private

  defp compute_ticks_positions([min, max], count, :linear) do
    Utils.linspace(min, max, count)
  end

  defp compute_ticks_positions([min, max], count, :log) do
    {min, max} |> Utils.log10() |> Utils.logspace(count)
  end
end
