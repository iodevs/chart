defmodule Chart.Gauge.View do
  @moduledoc false

  alias Chart.Internal.Utils
  alias Chart.Gauge.Settings
  import Chart.Gauge.Utils, only: [is_in_interval?: 2]

  def gauge_value_class(list_value_class, value) do
    list_value_class
    |> Enum.find({[], ""}, fn {interval, _class} -> is_in_interval?(value, interval) end)
    |> Kernel.elem(1)
  end

  def d_gauge_half_circle(%Settings{d_gauge_half_circle: {cx, cy, rx, ry}}) do
    # "M#{cx - rx}, #{cy} A#{rx}, #{ry} 0 0,1 #{cx + rx}, #{cy}"
    half_circle({cx, cy}, {rx, ry}, {rx, 0})
  end

  def gauge_value_half_circle(%Settings{range: {a, _b}}, value) when is_nil(value) or value < a do
    ""
  end

  def gauge_value_half_circle(
        %Settings{range: {_a, b}, gauge_center: {cx, cy}, gauge_radius: {rx, ry}},
        value
      )
      when b < value do
    # "M#{cx - rx}, #{cy} A#{rx}, #{ry} 0 0,1 #{cx + rx}, #{cy}"
    half_circle({cx, cy}, {rx, ry}, {rx, 0})
  end

  def gauge_value_half_circle(
        %Settings{range: {a, b}, gauge_center: {cx, cy}, gauge_radius: {rx, ry}},
        value
      ) do
    phi = Utils.value_to_angle(value, a, b)
    {end_rx, end_ry} = Utils.polar_to_cartesian(rx, phi)

    # "M#{cx - rx}, #{cy} A#{rx}, #{ry} 0 0,1 #{cx + end_rx}, #{cy - end_ry}"
    half_circle({cx, cy}, {rx, ry}, {end_rx, end_ry})
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

  def value(nil, _decimals) do
    ""
  end

  def value(val, decimals) do
    Utils.round_value(val, decimals)
  end

  # Private

  defp half_circle({cx, cy}, {rx, ry}, {end_rx, end_ry}) do
    "M#{cx - rx}, #{cy} A#{rx}, #{ry} 0 0,1 #{cx + end_rx}, #{cy - end_ry}"
  end
end
