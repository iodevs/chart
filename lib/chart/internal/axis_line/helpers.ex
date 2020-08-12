defmodule Chart.Internal.AxisLine.Helpers do
  @moduledoc false

  alias Chart.Internal.Utils

  def compute_ticks_positions(:x_axis, {pos_x, _pos_y}, {width, _height}, count, :linear) do
    Utils.linspace({pos_x, pos_x + width}, count)
  end

  def compute_ticks_positions(:x_axis, {pos_x, _pos_y}, {width, _height}, count, :log) do
    Utils.logspace({pos_x, pos_x + width}, count)
  end

  def compute_ticks_positions(:y_axis, {_pos_x, pos_y}, {_width, height}, count, :linear) do
    Utils.linspace({pos_y, pos_y + height}, count)
  end

  def compute_ticks_positions(:y_axis, {_pos_x, pos_y}, {_width, height}, count, :log) do
    Utils.logspace({pos_y, pos_y + height}, count)
  end
end
