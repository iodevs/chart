defmodule Chart.Internal.AxisLine.Label do
  @moduledoc false

  alias Chart.Internal.AxisLine.Helpers
  import Chart.Internal.Guards, only: [is_numbers: 2, is_turn: 1]

  @self_key :label

  defguard label_placement(pl) when pl in [:left, :center, :right, :top, :middle, :bottom]

  def new() do
    %{
      adjust_placement: {0, 0},
      placement: :center,
      rect_bg: :off,
      turn: :on,
      text: "",
      position: {0, 0}
    }
  end

  def add(settings, key) when is_map(settings) and is_atom(key) do
    put_in(settings, [key, @self_key], new())
  end

  # Setters

  @doc """
  adjust_placement :: {number, number}
  """
  def set_adjust_placement(settings, axis, {x, y} = adjust_placement)
      when is_map(settings) and is_atom(axis) and is_numbers(x, y) do
    settings
    |> put_in([axis, @self_key, :adjust_placement], adjust_placement)
    |> Helpers.recalculate_label_position(axis)
  end

  @doc """
  placement :: :left | :center | :right | :top | :middle | :bottom
  """
  def set_placement(settings, axis, placement)
      when is_map(settings) and is_atom(axis) and is_atom(placement) do
    settings
    |> put_in([axis, @self_key, :placement], placement)
    |> Helpers.recalculate_label_position(axis)
  end

  @doc """
  rect_bg :: :on | :off
  """
  def set_rect_bg(settings, axis, rect_bg)
      when is_map(settings) and is_turn(rect_bg) do
    put_in(settings, [axis, @self_key, :rect_bg], rect_bg)
  end

  @doc """
  turn :: :on | :off
  """
  def set_turn(settings, axis, turn)
      when is_map(settings) and is_turn(turn) do
    put_in(settings, [axis, @self_key, :turn], turn)
  end

  def set_text(settings, axis, text)
      when is_map(settings) and is_atom(axis) and is_binary(text) do
    put_in(settings, [axis, @self_key, :text], text)
  end
end
