defmodule Chart.Line.AxisSvg do
  @moduledoc false

  alias Chart.Line.View
  use Phoenix.HTML

  def render(settings) do
    assigns =
      settings
      |> Map.put(:view, View)

    x_axis = View.get_axis(settings, {1, 0})
    y_axis = View.get_axis(settings, {0, 1})

    ~E"""
    <g class="axis">
      <% y_minor_ticks = settings[y_axis].minor_ticks %>
      <defs>
        <line id="y-minor-line-ticks" x1="<%= y_minor_ticks.length %>"/>
      </defs>
      <g class="y-minor-ticks">
        <%= for py <- y_minor_ticks.positions do %>
          <use xlink:href="#y-minor-line-ticks"
            transform="<%= @view.translate_y_ticks(settings[y_axis].line, y_minor_ticks.length, y_minor_ticks.gap, py) %>" />
        <% end %>
      </g>

      <% y_major_ticks = settings[y_axis].major_ticks %>
      <defs>
        <line id="y-major-line-ticks" x1="<%= y_major_ticks.length %>"/>
      </defs>
      <g class="y-major-ticks">
        <%= for py <- y_major_ticks.positions do %>
          <use xlink:href="#y-major-line-ticks"
            transform="<%= @view.translate_y_ticks(settings[y_axis].line, y_major_ticks.length, y_major_ticks.gap, py) %>" />
        <% end %>
      </g>

      <% x_minor_ticks = settings[x_axis].minor_ticks %>
      <%= inspect x_minor_ticks %>

      <defs>
        <line id="x-minor-line-ticks" y1="<%= x_minor_ticks.length %>"/>
      </defs>
      <g class="x-minor-ticks">
        <%= for px <- x_minor_ticks.positions do %>
          <use xlink:href="#x-minor-line-ticks"
            transform="<%= @view.translate_x_ticks(settings[x_axis].line, x_minor_ticks.gap, px) %>" />
        <% end %>
      </g>

      <% x_major_ticks = settings[x_axis].major_ticks %>
      <defs>
        <line id="x-major-line-ticks" y1="<%= x_major_ticks.length %>"/>
      </defs>
      <g class="x-major-ticks">
        <%= for px <- x_major_ticks.positions do %>
          <use xlink:href="#x-major-line-ticks"
            transform="<%= @view.translate_x_ticks(settings[x_axis].line, x_major_ticks.gap, px) %>" />
        <% end %>
      </g>

      <% y_major_ticks_text = @view.y_ticks_label(settings[y_axis].line, settings[y_axis].major_ticks_text) %>
      <g class="y-major-ticks-label">
        <%= for {pos_x, pos_y, label} <- y_major_ticks_text do %>
          <text class="y-tick-label" x="<%= pos_x %>" y="<%= pos_y %>"
            alignment-baseline="middle" text-anchor="middle"
          ><%= label %></text>
        <% end %>
      </g>

      <% x_major_ticks_text = @view.x_ticks_label(settings[x_axis].line, settings[x_axis].major_ticks_text) %>
      <g class="x-major-ticks-label">
        <%= for {pos_x, pos_y, label} <- x_major_ticks_text do %>
          <text class="x-tick-label" x="<%= pos_x %>" y="<%= pos_y %>"
            alignment-baseline="middle" text-anchor="middle"
          ><%= label %></text>
        <% end %>
      </g>

      <% {x1, y1, x2, y2, thickness} =  @view.set_axis_line(settings[y_axis], {0, 1}) %>
      <line id="y_axis" x1="<%= x1 %>" y1="<%= y1 %>" x2="<%= x2 %>" y2="<%= y2 %>"
      stroke-width="<%= thickness %>" />

      <% {x1, y1, x2, y2, thickness} =  @view.set_axis_line(settings[x_axis], {1, 0}) %>
      <line id="x_axis" x1="<%= x1 %>" y1="<%= y1 %>" x2="<%= x2 %>" y2="<%= y2 %>"
      stroke-width="<%= thickness %>" />
    </g>
    """
  end
end
