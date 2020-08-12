defmodule Chart.Internal.Plot do
  @moduledoc false

  alias Chart.Internal.AxisLine.Helpers

  import Chart.Internal.Guards,
    only: [is_nonnegative_number: 1, is_positive_number: 2, is_number: 2]

  @self_key :plot

  def new() do
    %{
      axis: [],
      position: {100, 100},
      rect_bg_padding: {0, 0, 0, 0},
      size: {600, 400}
    }
  end

  def add(settings) when is_map(settings) do
    Map.put(settings, @self_key, new())
  end

  # Setters

  def set_position(settings, {x, y} = position)
      when is_map(settings) and is_number(x, y) do
    axis = settings.plot.axis

    settings
    |> put_in(
      [@self_key, :position],
      validate_position(position, settings.figure.viewbox, settings.plot.size)
    )
    |> Helpers.recalculate_ticks_positions(axis)
    |> Helpers.recalculate_line(axis)
    |> Helpers.recalculate_label_position(axis)
  end

  def set_rect_bg_padding(settings, rect_bg_padding) do
    put_in(
      settings,
      [@self_key, :rect_bg_padding],
      validate_rect_bg_padding(rect_bg_padding)
    )
  end

  def set_size(settings, {x, y} = size)
      when is_map(settings) and is_number(x, y) do
    axis = settings.plot.axis

    settings
    |> put_in(
      [@self_key, :size],
      validate_size(size, settings.figure.viewbox)
    )
    |> Helpers.recalculate_ticks_positions(axis)
    |> Helpers.recalculate_line(axis)
    |> Helpers.recalculate_label_position(axis)
  end

  # Private

  defp validate_position(
         {pos_x, pos_y} = position,
         {fig_width, fig_height},
         {plot_width, plot_height}
       )
       when is_positive_number(pos_x, pos_y) and
              pos_x + plot_width < fig_width and pos_y + plot_height < fig_height do
    position
  end

  defp validate_rect_bg_padding({top, right, bottom, left} = pad)
       when is_nonnegative_number(top) and is_nonnegative_number(right) and
              is_nonnegative_number(bottom) and is_nonnegative_number(left) do
    pad
  end

  defp validate_size({width, height} = size, {fig_width, fig_height})
       when is_positive_number(width, height) and
              width < fig_width and height < fig_height do
    size
  end
end
