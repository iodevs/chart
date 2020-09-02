defmodule Chart.Internal.Rectangle do
  @moduledoc false

  import Chart.Internal.Guards, only: [is_nonnegative_number: 1, is_positive_number: 1]

  @self_key :rect_bg

  def new() do
    %{
      padding: {0, 0, 0, 0},
      position: {0, 0},
      size: {0, 0}
    }
  end

  def add(settings, key \\ @self_key) when is_map(settings) and is_atom(key) do
    Map.put(settings, key, new())
  end

  # Setters

  def set_padding(settings, key \\ @self_key, {top, right, bottom, left} = padding)
      when is_map(settings) and is_atom(key) and is_nonnegative_number(top) and
             is_nonnegative_number(right) and is_nonnegative_number(bottom) and
             is_nonnegative_number(left) do
    put_in(settings, [key, :padding], padding)
  end

  def set_position(settings, key \\ @self_key, {x, y} = position)
      when is_map(settings) and is_atom(key) and is_number(x) and is_number(y) do
    put_in(settings, [key, :position], position)
  end

  def set_size(settings, key \\ @self_key, {x, y} = size)
      when is_map(settings) and is_atom(key) and is_positive_number(x) and
             is_positive_number(y) do
    put_in(settings, [key, :size], size)
  end
end
