defmodule Chart.Internal.BarLine.MajorTicks do
  @moduledoc false

  alias Chart.Internal.Utils
  import Chart.Internal.Guards, only: [is_positive_number: 1]

  @self_key :major_ticks
  @x_axis :x_axis

  def new() do
    %{
      gap: 0,
      length: 10,
      positions: []
    }
  end

  def add(%{axis_table: axis_table} = settings, axis \\ @x_axis)
      when is_map(settings) and is_map_key(axis_table, axis) do
    settings
    |> put_in([axis, @self_key], new())
  end

  # Setters

  def set_gap(%{axis_table: axis_table} = settings, axis, gap)
      when is_map(settings) and is_map_key(axis_table, axis) and is_number(gap) do
    put_in(settings, [axis, @self_key, :gap], gap)
  end

  def set_length(%{axis_table: axis_table} = settings, axis, length)
      when is_map(settings) and is_map_key(axis_table, axis) and is_positive_number(length) do
    put_in(settings, [axis, @self_key, :length], length)
  end

  def set_positions(chart) do
    settings = chart.settings
    {px1, _py1, px2, _py2} = settings[@x_axis][:line]
    count_bar = length(settings[@x_axis][:major_ticks_text][:labels])
    bar_width = get_bar_width(px2 - px1, count_bar, settings.bar.width)

    positions =
      {px1, px2}
      |> Utils.linspace(2 * count_bar + 1)
      |> Enum.drop_every(2)

    updated_settings =
      chart.settings
      |> put_in([:bar, :width], bar_width)
      |> put_in([@x_axis, @self_key, :positions], positions)
      |> put_in([@x_axis, :major_ticks_text, :positions], positions)

    Map.put(chart, :settings, updated_settings)
  end

  # Private

  defp get_bar_width(plot_width, count_bar, :auto) do
    plot_width / (count_bar + (count_bar + 1))
  end

  defp get_bar_width(_plot_width, _count_bar, width) when is_number(width) and 0 < width do
    width
  end
end
