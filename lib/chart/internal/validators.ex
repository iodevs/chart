defmodule Chart.Internal.Validators do
  @moduledoc false

  import Chart.Internal.Axis, only: [scale: 1]
  import Chart.Internal.Plot.Grid, only: [grid_placement: 1]
  import Chart.Internal.TextPosition, only: [text_position: 1]

  defguard turn(t) when t in [:on, :off]

  def validate_labels([]), do: []

  def validate_labels([str, _rest] = lbs) when is_list(lbs) and is_binary(str) do
    lbs
  end

  def validate_axis_tick_labels_format({:decimals, dec} = lf) when is_integer(dec) and 0 <= dec do
    lf
  end

  def validate_axis_tick_labels_format({:datetime, dt} = lf) when is_binary(dt) do
    lf
  end

  def validate_axis_scale(s) when scale(s) do
    s
  end

  def validate_decimals(decimals) when is_integer(decimals) and 0 <= decimals do
    decimals
  end

  def validate_number(number) when is_number(number) do
    number
  end

  def validate_list_of_tuples([]), do: []

  def validate_list_of_tuples([tpl | tl] = val_colors)
      when is_tuple(tpl) and is_list(tl) do
    val_colors
  end

  def validate_text_position({x, y} = position) when is_number(x) and is_number(y) do
    position
  end

  def validate_text_position(position) when text_position(position) do
    position
  end

  def validate_ticks_count(count) when is_integer(count) and 1 < count do
    count
  end

  def validate_grid_placement(pl) when grid_placement(pl) do
    pl
  end

  def validate_range({min, max} = range) when is_number(min) and is_number(max) and min < max do
    range
  end

  def validate_positive_number(number) when is_number(number) and 0 < number do
    number
  end

  def validate_string(string) when is_binary(string) do
    string
  end

  def validate_turn(t) when turn(t) do
    t
  end

  def validate_viewbox({width, height} = viewbox)
      when is_number(width) and is_number(height) and 0 < width and 0 < height do
    viewbox
  end

  def validate_plot_size({width, height} = size, {fig_width, fig_height})
      when is_number(width) and is_number(height) and 0 < width and 0 < height and
             width < fig_width and height < fig_height do
    size
  end

  def validate_rect_bg_padding({top, right, bottom, left} = pad)
      when is_number(top) and is_number(right) and is_number(bottom) and is_number(left) and
             0 <= top and 0 <= right and 0 <= bottom and 0 <= left do
    pad
  end

  def validate_plot_position(
        {pos_x, pos_y} = position,
        {{fig_width, fig_height}, {plot_width, plot_height}}
      )
      when is_number(pos_x) and is_number(pos_y) and 0 < pos_x and 0 < pos_y and
             pos_x + plot_width < fig_width and pos_y + plot_height < fig_height do
    position
  end
end
