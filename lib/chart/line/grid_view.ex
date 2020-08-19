defmodule Chart.Line.GridView do
  @moduledoc false

  def set_grid_line({_pos_x, pos_y}, {_w, h}, position, gap, {1, 0}) do
    {position, pos_y + gap, position, pos_y + h - gap}
  end

  def set_grid_line({pos_x, _pos_y}, {w, _h}, position, gap, {0, 1}) do
    {pos_x + gap, position, pos_x + w - gap, position}
  end
end
