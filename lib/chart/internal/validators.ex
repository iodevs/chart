defmodule Chart.Internal.Validators do
  @moduledoc false

  import Chart.Internal.TextPosition, only: [text_position: 1]
  import Chart.Internal.Plot.Grid, only: [grid_placement: 1, grid_turn: 1]

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

  def validate_major_ticks_count(count) when is_integer(count) and 1 < count do
    count
  end

  def validate_grid_placement(pl) when grid_placement(pl) do
    pl
  end

  def validate_grid_turn(t) when grid_turn(t) do
    t
  end

  def validate_range({min, max} = range) when is_number(min) and is_number(max) and min < max do
    range
  end

  def validate_positive_number(number) when 0 < number and is_number(number) do
    number
  end

  def validate_string(string) when is_binary(string) do
    string
  end

  def validate_tuple_numbers({width, height} = viewbox)
      when is_number(width) and is_number(height) and 0 < width and 0 < height do
    viewbox
  end

  def validate_plot_size({width, height} = size, {limit_w, limit_h})
      when is_number(width) and is_number(height) and 0 < width and 0 < height and
             width < limit_w and height < limit_h do
    size
  end
end
