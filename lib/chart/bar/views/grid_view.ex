defmodule Chart.Bar.Views.GridView do
  @moduledoc false

  def set_grid_line({_pos_x, pos_y}, {_w, h}, position, gap, {1, 0}) do
    {position, pos_y + gap, position, pos_y + h - gap}
  end

  def set_grid_line({pos_x, _pos_y}, {w, _h}, position, gap, {0, 1}) do
    {pos_x + gap, position, pos_x + w - gap, position}
  end

  def css_class_grid_lines(grid_type) do
    "grid-#{convert_grid_type(grid_type)}-bars"
  end

  def css_class_grid_line(grid_type) do
    "grid-#{convert_grid_type(grid_type)}-bar"
  end

  # Private

  defp convert_grid_type(gt) when is_atom(gt) do
    gt |> Atom.to_string() |> String.replace("_", "-")
  end
end
