defmodule Chart.Gauge.View do
  @moduledoc false

  alias Chart.Gauge.Settings

  def d_gauge_half_circle(%Settings{d_gauge_half_circle: {cx, cy, rx, ry}}) do
    "M#{cx - rx}, #{cy} A#{rx}, #{ry} 0 0,1 #{cx + rx}, #{cy}"
  end

  def line_width(x, y, width) do
    "M#{x}, #{y}, l0, #{width}"
  end

  def rotate(angle, {cx, cy}) do
    "rotate(#{angle}, #{cx}, #{cy})"
  end

  def translate({x, y}) do
    "translate(#{x}, #{y})"
  end
end
