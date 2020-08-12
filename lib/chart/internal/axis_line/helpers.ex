defmodule Chart.Internal.AxisLine.Helpers do
  @moduledoc false

  alias Chart.Internal.Utils

  @gap_from_bottom 60
  @gap_from_left 20

  def recalculate_ticks_labels(settings, axis) do
    settings_ax = settings[axis]
    major_ticks_text = settings_ax.major_ticks_text

    labels =
      compute_labels(
        major_ticks_text.range,
        settings_ax.major_ticks.count,
        settings_ax.scale,
        major_ticks_text.format
      )
      |> apply_format(major_ticks_text.format)

    put_in(settings, [axis, :major_ticks_text, :labels], labels)
  end

  def recalculate_label_position(settings, axis) when is_map(settings) and is_list(axis) do
    Enum.reduce(axis, settings, fn ax, acc -> recalculate_label_position(acc, ax) end)
  end

  def recalculate_label_position(settings, axis)
      when is_map(settings) and is_atom(axis) do
    label = settings[axis].label

    position =
      compute_label_position(
        label.placement,
        label.adjust_placement,
        settings.plot.position,
        settings.plot.size
      )

    put_in(settings, [axis, :label, :position], position)
  end

  def recalculate_line(settings, axis) when is_map(settings) and is_list(axis) do
    Enum.reduce(axis, settings, fn ax, acc -> recalculate_line(acc, ax) end)
  end

  def recalculate_line(settings, axis) when is_map(settings) and is_atom(axis) do
    line =
      compute_line(axis, settings.plot.position, settings.plot.size, settings[axis].thickness)

    put_in(settings, [axis, :line], line)
  end

  def recalculate_ticks_positions(settings, axis) when is_map(settings) and is_list(axis) do
    Enum.reduce(axis, settings, fn ax, acc -> recalculate_ticks_positions(acc, ax) end)
  end

  def recalculate_ticks_positions(settings, axis) when is_map(settings) and is_atom(axis) do
    settings_ax = settings[axis]

    major_ticks_positions =
      compute_ticks_positions(
        axis,
        settings.plot.position,
        settings.plot.size,
        settings_ax.major_ticks.count,
        settings_ax.scale
      )

    minor_ticks_positions =
      compute_ticks_positions(
        axis,
        settings.plot.position,
        settings.plot.size,
        settings_ax.minor_ticks.count,
        settings_ax.scale
      )

    settings
    |> put_in([axis, :major_ticks, :positions], major_ticks_positions)
    |> put_in([axis, :minor_ticks, :positions], minor_ticks_positions)
    |> put_in([axis, :major_ticks_text, :positions], major_ticks_positions)
  end

  # Private

  defp apply_format(labels, {:decimals, dec}) do
    Enum.map(labels, &Utils.round_value(&1, dec))
  end

  defp apply_format(labels, {:datetime, dt}) do
    Enum.map(labels, &Utils.datetime_format(&1, dt))
  end

  defp compute_labels(range, count, :linear, {:decimals, _dec}) do
    Utils.linspace(range, count)
  end

  defp compute_labels(range, count, :log, {:decimals, _dec}) do
    Utils.logspace(range, count)
  end

  defp compute_labels(range, count, :linear, {:datetime, _dt}) do
    Utils.linspace(range, count)
  end

  # compute_label_position(placement, adjust_placement, plot_position, plot_size)
  defp compute_label_position(:left, {ad_pl_x, ad_pl_y}, {pos_x, pos_y}, {_width, height}) do
    {pos_x + ad_pl_x, pos_y + height + @gap_from_bottom + ad_pl_y}
  end

  defp compute_label_position(:center, {ad_pl_x, ad_pl_y}, {pos_x, pos_y}, {width, height}) do
    {pos_x + width / 2 + ad_pl_x, pos_y + height + @gap_from_bottom + ad_pl_y}
  end

  defp compute_label_position(:right, {ad_pl_x, ad_pl_y}, {pos_x, pos_y}, {width, height}) do
    {pos_x + width + ad_pl_x, pos_y + height + @gap_from_bottom + ad_pl_y}
  end

  defp compute_label_position(:top, {ad_pl_x, ad_pl_y}, {pos_x, pos_y}, {_width, _height}) do
    {pos_x - @gap_from_left + ad_pl_x, pos_y + ad_pl_y}
  end

  defp compute_label_position(:middle, {ad_pl_x, ad_pl_y}, {pos_x, pos_y}, {_width, height}) do
    {pos_x - @gap_from_left + ad_pl_x, pos_y + height / 2 + ad_pl_y}
  end

  defp compute_label_position(:bottom, {ad_pl_x, ad_pl_y}, {pos_x, pos_y}, {_width, height}) do
    {pos_x - @gap_from_left + ad_pl_x, pos_y + height + ad_pl_y}
  end

  defp compute_line(:x_axis, {pos_x, pos_y}, {width, height}, thickness) do
    {pos_x, pos_y + height, pos_x + width, pos_y + height, thickness}
  end

  defp compute_line(:y_axis, {pos_x, pos_y}, {_width, height}, thickness) do
    {pos_x, pos_y, pos_x, pos_y + height + thickness / 2, thickness}
  end

  defp compute_ticks_positions(:x_axis, {pos_x, _pos_y}, {width, _height}, count, :linear) do
    Utils.linspace({pos_x, pos_x + width}, count)
  end

  defp compute_ticks_positions(:x_axis, {pos_x, _pos_y}, {width, _height}, count, :log) do
    Utils.logspace({pos_x, pos_x + width}, count)
  end

  defp compute_ticks_positions(:y_axis, {_pos_x, pos_y}, {_width, height}, count, :linear) do
    Utils.linspace({pos_y, pos_y + height}, count)
  end

  defp compute_ticks_positions(:y_axis, {_pos_x, pos_y}, {_width, height}, count, :log) do
    Utils.logspace({pos_y, pos_y + height}, count)
  end
end
