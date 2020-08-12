defmodule Chart.Internal.Text do
  @moduledoc false

  import Chart.Internal.Guards, only: [is_number: 2, is_turn: 1]

  @self_key :text

  def new() do
    %{
      position: {0, 0},
      rect_bg: :off,
      turn: :on,
      text: ""
    }
  end

  def add(settings) when is_map(settings) do
    Map.put(settings, @self_key, new())
  end

  # Setters

  def set_position(settings, {x, y} = position)
      when is_map(settings) and is_number(x, y) do
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
