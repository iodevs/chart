defmodule Chart.Internal.AxisLine.Helpers do
  @moduledoc false

  alias Chart.Internal.Utils

  def compute_ticks_positions({1, 0}, {pos_x, _pos_y}, {width, _height}, count, :linear) do
    Utils.linspace({pos_x, pos_x + width}, count)
  end

  def compute_ticks_positions({1, 0}, {pos_x, _pos_y}, {width, _height}, count, :log) do
    {pos_x, pos_x + width} |> log10() |> Utils.logspace(count)
  end

  def compute_ticks_positions({0, 1}, {_pos_x, pos_y}, {_width, height}, count, :linear) do
    Utils.linspace({pos_y, pos_y + height}, count)
  end

  def compute_ticks_positions({0, 1}, {_pos_x, pos_y}, {_width, height}, count, :log) do
    {pos_y, pos_y + height} |> log10() |> Utils.logspace(count)
  end

  # Private

  def log10({a, b}) do
    {:math.log10(a), :math.log10(b)}
  end
end
