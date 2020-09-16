defmodule Chart.Line.Svg do
  @moduledoc false

  alias Chart.Line.Templates.{AxisSvg, GridSvg}
  alias Chart.Line.View

  use Phoenix.HTML

  def generate(line) do
    line_settings = line.settings
    {fig_width, fig_height} = line_settings.figure.viewbox
    {title_pos_x, title_pos_y} = line_settings.title.position

    {rect_bg_pos_x, rect_bg_pos_y, rect_bg_width, rect_bg_height} =
      View.plot_rect_bg(line_settings.plot)

    assigns =
      line_settings
      |> Map.put(:data, line.storage.data)
      |> Map.put(:fig_width, fig_width)
      |> Map.put(:fig_height, fig_height)
      |> Map.put(:title_pos_x, title_pos_x)
      |> Map.put(:title_pos_y, title_pos_y)
      |> Map.put(:rect_bg_pos_x, rect_bg_pos_x)
      |> Map.put(:rect_bg_pos_y, rect_bg_pos_y)
      |> Map.put(:rect_bg_width, rect_bg_width)
      |> Map.put(:rect_bg_height, rect_bg_height)
      |> Map.put(:axis, AxisSvg.render(line_settings))
      |> Map.put(:grid, GridSvg.render(line_settings))

    ~E"""
    <svg version="1.2" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
      viewbox="0 0 <%= @fig_width %> <%= @fig_height %>" >

      <rect id="figure_bg" width="100%" height="100%" />

      <text id="title" x="<%= @title_pos_x %>" y="<%= @title_pos_y %>"
        alignment-baseline="middle" text-anchor="middle"
      ><%= @title.text %></text>

      <rect id="plot" x="<%= @rect_bg_pos_x %>" y="<%= @rect_bg_pos_y %>"
        width="<%= @rect_bg_width %>" height="<%= @rect_bg_height %>" />

      <%= @grid %>

      <g class="lines">
        <%= for {data, id_line} <- Enum.with_index(@data) do %>
          <polyline id="line-<%= id_line %>" points="<%= View.set_line_points(line_settings, data) %>" />
        <% end %>
      </g>

      <%= @axis %>
    </svg>
    """
  end
end
