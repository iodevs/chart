defmodule Chart.Gauge.Validators do
  @moduledoc false

  def validate_decimals(decimals) when is_integer(decimals) and 0 <= decimals do
    decimals
  end

  def validate_list_of_tuples([]), do: []

  def validate_list_of_tuples([tpl | tl] = val_colors)
      when is_tuple(tpl) and is_list(tl) do
    val_colors
  end

  def validate_number(number) when is_number(number) do
    number
  end

  def validate_positive_number(number) when is_number(number) and 0 < number do
    number
  end

  def validate_range({min, max} = range) when is_number(min) and is_number(max) and min < max do
    range
  end

  def validate_position({x, y} = position) when is_number(x) and is_number(y) do
    position
  end

  def validate_ticks_count(count) when is_integer(count) and 1 < count do
    count
  end

  def validate_viewbox({width, height} = viewbox)
      when is_number(width) and is_number(height) and 0 < width and 0 < height do
    viewbox
  end
end
