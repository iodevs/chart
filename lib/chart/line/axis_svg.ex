defmodule Chart.Line.AxisSvg do
  @moduledoc false

  alias Chart.Line.{AxisView, View}
  use Phoenix.HTML

  def render(settings) do
    assigns =
      settings
      |> Map.put(:view, View)
      |> Map.put(:axis_view, AxisView)

    ~E"""
    <g class="axis">
    <%= for {axis, vector} <- @axis_table do %>
      <% settings_ax = settings[axis] %>
      <% minor_ticks = settings_ax.minor_ticks %>
      <defs>
        <% {x1, y1} = @axis_view.set_axis_tick(minor_ticks.length, vector) %>
        <% css_id = @axis_view.css_id_axis_minor_line_ticks(axis) %>
        <line id="<%= css_id %>" x1="<%= x1 %>" y1="<%= y1 %>" />
      </defs>
      <g class="<%= @axis_view.css_class_axis_minor_ticks(axis) %>">
        <%= for position <- minor_ticks.positions do %>
          <use xlink:href="#<%= css_id %>"
            transform="<%= @view.translate_axis_ticks(settings_ax.line, minor_ticks.length, minor_ticks.gap, position, vector) %>" />
        <% end %>
      </g>

      <% major_ticks = settings_ax.major_ticks %>
      <defs>
        <% {x1, y1} = @axis_view.set_axis_tick(major_ticks.length, vector) %>
        <% css_id = @axis_view.css_id_axis_major_line_ticks(axis) %>
        <line id="<%= css_id %>" x1="<%= x1 %>" y1="<%= y1 %>" />
      </defs>
      <g class="<%= @axis_view.css_class_axis_major_ticks(axis) %>">
        <%= for position <- major_ticks.positions do %>
          <use xlink:href="#<%= css_id %>"
            transform="<%= @view.translate_axis_ticks(settings_ax.line, major_ticks.length, major_ticks.gap, position, vector) %>" />
        <% end %>
      </g>

      <% major_ticks_text = @view.axis_ticks_label(settings_ax.line, settings_ax.major_ticks_text, vector) %>
      <g class="<%= @axis_view.css_class_axis_major_ticks_label(axis) %>">
        <%= for {pos_x, pos_y, label} <- major_ticks_text do %>
          <text class="<%= @axis_view.css_class_axis_tick_label(axis) %>" x="<%= pos_x %>" y="<%= pos_y %>"
            alignment-baseline="middle" text-anchor="middle"
          ><%= label %></text>
        <% end %>
      </g>

      <% {x1, y1, x2, y2, thickness} =  @view.set_axis_line(settings_ax, vector) %>
      <line id="<%= Atom.to_string(axis) %>" x1="<%= x1 %>" y1="<%= y1 %>" x2="<%= x2 %>" y2="<%= y2 %>"
      stroke-width="<%= thickness %>" />

      <g class="axis-label">
        <% {pos_x, pos_y} = settings_ax.label.position %>
          <text id="<%= @axis_view.css_id_axis_label(axis) %>" x="<%= pos_x %>" y="<%= pos_y %>"
            alignment-baseline="middle" text-anchor="middle"
          ><%= settings_ax.label.text %></text>
      </g>
    <% end %>
    </g>
    """
  end
end
