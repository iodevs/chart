defmodule Chart.Line.View do
  @moduledoc false

  def plot_rect_bg(plot) do
    {px, py} = plot.position
    {width, height} = plot.size
    {top, right, bottom, left} = plot.rect_bg_padding

    {px - left, py - top, width + left + right, height + top + bottom}
  end
end
