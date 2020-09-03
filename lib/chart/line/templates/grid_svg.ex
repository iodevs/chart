defmodule Chart.Line.Templates.GridSvg do
  @moduledoc false

  alias Chart.Line.Views.GridView
  use Phoenix.HTML

  def render(settings) do
    assigns =
      settings
      |> Map.put(:grid_view, GridView)

    ~E"""
    <g class="grid">
    <%= for {axis, vector} <- @axis_table do %>
      <% plot = settings.plot %>

      <%= if settings.grid.minor_visibility == :visible do %>
        <% minor_ticks = settings[axis].minor_ticks %>
        <g class="grid-minor-lines">
          <%= for position <- minor_ticks.positions do %>
            <% {x1, y1, x2, y2} = @grid_view.set_grid_line(plot.position, plot.size, position, settings.grid.minor_gap, vector) %>
            <line class="grid-minor-lines" x1="<%= x1 %>" y1="<%= y1 %>" x2="<%= x2 %>" y2="<%= y2 %>" />
          <% end %>
        </g>
      <% end %>

      <%= if settings.grid.major_visibility == :visible do %>
        <% major_ticks = settings[axis].major_ticks %>
        <g class="grid-major-lines">
          <%= for position <- major_ticks.positions |> Enum.slice(1..-2) do %>
            <% {x1, y1, x2, y2} = @grid_view.set_grid_line(plot.position, plot.size, position, settings.grid.major_gap, vector) %>
            <line class="grid-major-lines" x1="<%= x1 %>" y1="<%= y1 %>" x2="<%= x2 %>" y2="<%= y2 %>" />
          <% end %>
        </g>
      <% end %>

    <% end %>
    </g>
    """
  end
end
