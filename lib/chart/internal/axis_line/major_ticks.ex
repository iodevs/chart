defmodule Chart.Internal.AxisLine.MajorTicks do
  @moduledoc false

  alias Chart.Internal.AxisLine.MajorTicksText
  alias Chart.Internal.Utils
  import Chart.Internal.Guards, only: [is_positive_number: 1]

  @self_key :major_ticks

  def new() do
    %{
      count: 10,
      gap: 0,
      length: 15,
      positions: []
    }
  end

  def add(%{axis_table: axis_table} = settings, axis)
      when is_map(settings) and is_map_key(axis_table, axis) do
    settings
    |> put_in([axis, @self_key], new())
    |> set_positions(axis)
  end

  # Setters

  def set_count(%{axis_table: axis_table} = settings, axis, count)
      when is_map(settings) and is_map_key(axis_table, axis) and is_integer(count) and 1 < count do
    settings
    |> put_in([axis, @self_key, :count], count)
    |> set_positions(axis)
    |> MajorTicksText.set_labels(axis)
    |> MajorTicksText.set_positions(axis)
  end

  def set_gap(%{axis_table: axis_table} = settings, axis, gap)
      when is_map(settings) and is_map_key(axis_table, axis) and is_number(gap) do
    put_in(settings, [axis, @self_key, :gap], gap)
  end

  def set_length(%{axis_table: axis_table} = settings, axis, length)
      when is_map(settings) and is_map_key(axis_table, axis) and is_positive_number(length) do
    put_in(settings, [axis, @self_key, :length], length)
  end

  def set_positions(settings, vector) when is_map(settings) and is_tuple(vector) do
    axis = settings.axis_table |> Utils.get_axis_for_vector(vector)

    set_positions(settings, axis)
  end

  def set_positions(%{axis_table: axis_table} = settings, axis)
      when is_map(settings) and is_map_key(axis_table, axis) do
    settings_ax = settings[axis]

    positions =
      compute_ticks_positions(
        settings_ax.vector,
        settings.plot.position,
        settings.plot.size,
        settings_ax.major_ticks.count + 1,
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
