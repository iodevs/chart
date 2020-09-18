defmodule Chart.Line.View do
  @moduledoc false

  def plot_rect_bg(%{
        position: {px, py},
        size: {width, height},
        padding: {top, right, bottom, left}
      }) do
    {px - left, py - top, width + left + right, height + top + bottom}
  end
end
