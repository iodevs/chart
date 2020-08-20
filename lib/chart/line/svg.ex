defmodule Chart.Chart.Line.Svg do
  @moduledoc false

  alias Chart.Line.{AxisSvg, GridSvg, View}

  use Phoenix.HTML

  def generate(line) do
    line_settings = line.settings

    assigns =
      line_settings
      |> Map.put(:data, line.data)
      |> Map.put(:view, View)
      |> Map.put(:axis, AxisSvg.render(line_settings))
      |> Map.put(:grid, GridSvg.render(line_settings))

    ~E"""
    <% {width, height} = @figure.viewbox %>
    <svg version="1.2" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
      viewbox="0 0 <%= width %> <%= height %>" >

      <rect id="figure_bg" width="100%" height="100%" />

      <% {pos_x, pos_y} = @title.position %>
      <text id="title" x="<%= pos_x %>" y="<%= pos_y %>"
        alignment-baseline="middle" text-anchor="middle"
      ><%= @title.text %></text>

      <% {pos_x, pos_y, width, height} = @view.plot_rect_bg(@plot) %>
      <rect id="plot" x="<%= pos_x %>" y="<%= pos_y %>" width="<%= width %>" height="<%= height %>" />

      <%= @grid %>
      <%= @axis %>

    </svg>
    """
  end
end
