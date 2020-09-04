defmodule Chart.Line.Templates.GridSvg do
  @moduledoc false

  alias Chart.Line.Views.GridView
  alias Chart.Internal.Utils
  use Phoenix.HTML

  def render(settings) do
    x_axis = Utils.get_axis_for_vector(settings.axis_table, {1, 0})
    y_axis = Utils.get_axis_for_vector(settings.axis_table, {0, 1})

    assigns =
      %{}
      |> Map.put(:x_major, grid_render(settings, [x_axis, :x_major, :plot, :major_ticks]))
      |> Map.put(:x_minor, grid_render(settings, [x_axis, :x_minor, :plot, :minor_ticks]))
      |> Map.put(:y_major, grid_render(settings, [y_axis, :y_major, :plot, :major_ticks]))
      |> Map.put(:y_minor, grid_render(settings, [y_axis, :y_minor, :plot, :minor_ticks]))

    ~E"""
    <g class="grid"><%= @y_minor %><%= @y_major %><%= @x_minor %><%= @x_major %></g>
    """
  end

  # Private

  defp grid_render(%{grid: grid} = settings, [axis, grid_type, plot, ticks_type])
       when is_map_key(grid, grid_type) do
    plot = settings[plot]
    ticks = settings[axis][ticks_type]
    vector = settings[:axis_table][axis]

    assigns =
      %{}
      |> Map.put(:css_class_grid_lines, GridView.css_class_grid_lines(grid_type))
      |> Map.put(:css_class_grid_line, GridView.css_class_grid_line(grid_type))

    ~E"""
    <g class="<%= @css_class_grid_lines %>">
      <%= for position <- ticks.positions do %>
        <% {x1, y1, x2, y2} = GridView.set_grid_line(plot.position, plot.size, position, settings[:grid][grid_type].gap, vector) %>
        <line class="<%= @css_class_grid_line %>" x1="<%= x1 %>" y1="<%= y1 %>" x2="<%= x2 %>" y2="<%= y2 %>" />
      <% end %>
    </g>
    """
  end

  defp grid_render(_settings, _keys) do
    ~E"""
    """
  end
end
