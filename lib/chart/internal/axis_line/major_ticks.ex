defmodule Chart.Internal.AxisLine.MajorTicks do
  @moduledoc false

  alias Chart.Internal.AxisLine.MajorTicksText
  alias Chart.Internal.Utils
  import Chart.Internal.Guards, only: [is_positive_number: 1]

  @self_key :major_ticks

  def new() do
    %{
      count: 11,
      gap: 0,
      length: 15,
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
    |> MajorTicksText.set_labels(axis)
  end

  def set_gap(settings, axis, gap) when is_map(settings) and is_atom(axis) and is_number(gap) do
    put_in(settings, [axis, @self_key, :gap], gap)
  end

  def set_length(settings, axis, length)
      when is_map(settings) and is_atom(axis) and is_positive_number(length) do
    put_in(settings, [axis, @self_key, :length], length)
  end

  def set_positions(settings, vector) when is_map(settings) and is_tuple(vector) do
    axis = settings |> Utils.find_axis_for_vector(vector) |> hd()

    set_positions(settings, axis)
  end

  def set_positions(settings, axis) when is_map(settings) and is_atom(axis) do
    settings_ax = settings[axis]

    positions =
      compute_ticks_positions(
        settings_ax.vector,
        settings.plot.position,
        settings.plot.size,
        settings_ax.major_ticks.count,
        settings_ax.scale
      )

    put_in(settings, [axis, @self_key, :positions], positions)
  end

  # Private

  defp compute_ticks_positions({1, 0}, {pos_x, _pos_y}, {width, _height}, count, :linear) do
    Utils.linspace({pos_x, pos_x + width}, count)
  end

  defp compute_ticks_positions({1, 0}, {pos_x, _pos_y}, {width, _height}, count, :log) do
    {pos_x, pos_x + width} |> Utils.log10() |> Utils.logspace(count)
  end

  defp compute_ticks_positions({0, 1}, {_pos_x, pos_y}, {_width, height}, count, :linear) do
    Utils.linspace({pos_y, pos_y + height}, count)
  end

  defp compute_ticks_positions({0, 1}, {_pos_x, pos_y}, {_width, height}, count, :log) do
    {pos_y, pos_y + height} |> Utils.log10() |> Utils.logspace(count)
  end
end
