defmodule Chart.Internal.Title do
  @moduledoc false

  alias Chart.Internal.Text
  import Chart.Internal.Guards, only: [is_turn: 1]

  @self_key :title

  def add(settings) when is_map(settings) do
    Map.put(settings, @self_key, Text.new())
  end

  # Setters

  def set_position(settings, {x, y} = position)
      when is_map(settings) and is_number(x) and is_number(y) do
    put_in(settings, [@self_key, :position], position)
  end

  def set_rect_bg(settings, rect_bg)
      when is_map(settings) and is_turn(rect_bg) do
    put_in(settings, [@self_key, :rect_bg], rect_bg)
  end

  def set_turn(settings, turn)
      when is_map(settings) and is_turn(turn) do
    put_in(settings, [@self_key, :turn], turn)
  end

  def set_text(settings, text)
      when is_map(settings) and is_binary(text) do
    put_in(settings, [@self_key, :text], text)
  end
end
