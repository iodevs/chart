defmodule Chart.Line.AxisSvg do
  @moduledoc false

  alias Chart.Line.View
  use Phoenix.HTML

  def render(settings) do
    assigns =
      settings
      |> Map.put(:view, View)

    ~E"""
    <g class="axis">
    <%= for {axis, vector} <- @axis_table do %>
      <% settings_ax = settings[axis] %>
      <% minor_ticks = settings_ax.minor_ticks %>
      <defs>
        <%= case vector do %>
          <% {1, 0} -> %><line id="<%= Atom.to_string(axis) %>-minor-line-ticks" y1="<%= minor_ticks.length %>"/>
          <% {0, 1} -> %><line id="<%= Atom.to_string(axis) %>-minor-line-ticks" x1="<%= minor_ticks.length %>"/>
        <% end%>
      </defs>
      <g class="<%= Atom.to_string(axis) %>-minor-ticks">
        <%= for position <- minor_ticks.positions do %>
          <use xlink:href="#<%= Atom.to_string(axis) %>-minor-line-ticks"
            transform="<%= @view.translate_axis_ticks(settings_ax.line, minor_ticks.length, minor_ticks.gap, position, vector) %>" />
        <% end %>
      </g>

      <% major_ticks = settings_ax.major_ticks %>
      <defs>
        <%= case vector do %>
          <% {1, 0} -> %><line id="<%= Atom.to_string(axis) %>-major-line-ticks" y1="<%= major_ticks.length %>"/>
          <% {0, 1} -> %><line id="<%= Atom.to_string(axis) %>-major-line-ticks" x1="<%= major_ticks.length %>"/>
        <% end%>
      </defs>
      <g class="<%= Atom.to_string(axis) %>-major-ticks">
        <%= for position <- major_ticks.positions do %>
          <use xlink:href="#<%= Atom.to_string(axis) %>-major-line-ticks"
            transform="<%= @view.translate_axis_ticks(settings_ax.line, major_ticks.length, major_ticks.gap, position, vector) %>" />
        <% end %>
      </g>

      <% major_ticks_text = @view.axis_ticks_label(settings_ax.line, settings_ax.major_ticks_text, vector) %>
      <g class="<%= Atom.to_string(axis) %>-major-ticks-label">
        <%= for {pos_x, pos_y, label} <- major_ticks_text do %>
          <text class="<%= Atom.to_string(axis) %>-tick-label" x="<%= pos_x %>" y="<%= pos_y %>"
            alignment-baseline="middle" text-anchor="middle"
          ><%= label %></text>
        <% end %>
      </g>

      <% {x1, y1, x2, y2, thickness} =  @view.set_axis_line(settings_ax, vector) %>
      <line id="<%= Atom.to_string(axis) %>" x1="<%= x1 %>" y1="<%= y1 %>" x2="<%= x2 %>" y2="<%= y2 %>"
      stroke-width="<%= thickness %>" />

      <g class="axis-label">
        <% {pos_x, pos_y} = settings_ax.label.position %>
          <text id="<%= Atom.to_string(axis) %>-label" x="<%= pos_x %>" y="<%= pos_y %>"
            alignment-baseline="middle" text-anchor="middle"
          ><%= settings_ax.label.text %></text>
      </g>
    <% end %>
    </g>
    """
  end
end
