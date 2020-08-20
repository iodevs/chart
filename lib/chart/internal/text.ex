defmodule Chart.Internal.Text do
  @moduledoc false

  import Chart.Internal.Guards, only: [is_visibility: 1]

  @self_key :text

  def new() do
    %{
      position: {0, 0},
      rect_bg: :none,
      visibility: :visible,
      text: ""
    }
  end

  def add(settings) when is_map(settings) do
    Map.put(settings, @self_key, new())
  end

  # Setters

  def set_position(settings, {x, y} = position)
      when is_map(settings) and is_number(x) and is_number(y) do
    put_in(settings, [@self_key, :position], position)
  end

  def set_rect_bg(settings, rect_bg)
      when is_map(settings) and is_visibility(rect_bg) do
    put_in(settings, [@self_key, :rect_bg], rect_bg)
  end

  def set_visibility(settings, visibility)
      when is_map(settings) and is_visibility(visibility) do
    put_in(settings, [@self_key, :visibility], visibility)
  end

  def set_text(settings, text)
      when is_map(settings) and is_binary(text) do
    put_in(settings, [@self_key, :text], text)
  end
end
