defmodule Chart.Internal.Text do
  @moduledoc false

  alias Chart.Internal.Rectangle
  import Chart.Internal.Guards, only: [is_nonnegative_number: 1, is_positive_number: 1]

  @self_key :text

  def new() do
    %{
      position: {0, 0},
      rect_bg: nil,
      text: ""
    }
  end

  def add(settings, key \\ @self_key) when is_map(settings) and is_atom(key) do
    Map.put(settings, key, new())
  end

  def add_rect_bg(settings, key \\ @self_key) when is_map(settings) and is_atom(key) do
    put_in(
      settings,
      [key, :rect_bg],
      Rectangle.new() |> Map.put(:position, settings[key].position)
    )
  end

  # Setters

  def set_position(settings, key \\ @self_key, {x, y} = position)
      when is_map(settings) and is_atom(key) and is_number(x) and is_number(y) do
    settings
    |> put_in([key, :position], position)
    |> set_rect_bg_position(key, position, settings[key].rect_bg)
  end

  def set_text(settings, key \\ @self_key, text)
      when is_map(settings) and is_atom(key) and is_binary(text) do
    put_in(settings, [key, :text], text)
  end

  # Setters for rectangle background

  def set_rect_bg_size(settings, key \\ @self_key, {w, h} = size)
      when is_map(settings) and is_atom(key) and is_positive_number(w) and is_positive_number(h) do
    put_in(settings, [key, :rect_bg, :size], size)
  end

  def set_rect_bg_padding(settings, key \\ @self_key, {top, right, bottom, left} = padding)
      when is_map(settings) and is_atom(key) and is_nonnegative_number(top) and
             is_nonnegative_number(right) and is_nonnegative_number(bottom) and
             is_nonnegative_number(left) do
    put_in(settings, [key, :rect_bg, :padding], padding)
  end

  # Private

  defp set_rect_bg_position(settings, _key, _position, nil), do: settings

  defp set_rect_bg_position(settings, key, position, _rect)
       when is_map(settings) and is_tuple(position) do
    put_in(settings, [key, :rect_bg, :position], position)
  end
end
