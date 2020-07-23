defmodule Chart.Gauge.Svg do
  @moduledoc false

  alias Chart.Gauge
  alias Chart.Gauge.View

  use Phoenix.HTML

  def generate(%Gauge{} = gauge) do
    assigns =
      gauge
      |> Map.from_struct()
      |> Map.put(:view, View)

    ~E"""
    <svg version="1.2" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
      viewbox="0 0 <%= elem(@settings.viewbox, 0) %> <%= elem(@settings.viewbox, 1) %>" >

      <defs>
        <line id="major-line-ticks"
          x1="<%= @settings.major_ticks.length %>"
          transform="<%= @view.translate(@settings.major_ticks.translate) %>" />
      </defs>
      <g class="major-ticks">
        <%= for angle <- @settings.major_ticks.positions do %>
          <use xlink:href="#major-line-ticks"
            transform="<%= @view.rotate(angle, @settings.gauge_center) %>" />
        <% end %>
      </g>

      <g class="major-ticks-text">
        <%= for {x, y, tick_value, text_anchor} <- @settings.major_ticks_text.positions do %>
          <text class="major-text"
            x="<%= x %>" y="<%= y %>"
            text-anchor="<%= text_anchor %>"
            ><%= tick_value %>
          </text>
        <% end %>
      </g>

      <g class="gauge">
        <g class="gauge-bg-border-bottom-lines">
          <path id="gauge-bg-border"
            d="<%= @view.d_gauge_half_circle(@settings) %>">
          </path>
          <%= for {x, y, width} <- @settings.d_gauge_bg_border_bottom_lines do %>
            <path class="gauge-bg-border-bottom-lines"
              d="<%= @view.line_width(x, y, width) %>">
            </path>
          <% end %>
        </g>

        <path id="gauge-bg"
          d="<%= @view.d_gauge_half_circle(@settings) %>">
        </path>
        <path id="gauge-value"
          <%= if !Enum.empty?(@settings.gauge_value_class) do %>
            class="<%= @view.gauge_value_class(@settings.gauge_value_class, @data) %>"
          <% end %>
          d="<%= @view.gauge_value_half_circle(@settings, @data) %>">
        </path>
      </g>

      <%= if !Enum.empty?(@settings.thresholds.positions_with_class_name) do %>
        <g class="thresholds">
          <%= for {x, y, width, angle, class} <- @settings.thresholds.d_thresholds_with_class do %>
            <path class="<%= class %>"
              d="<%= @view.line_width(x, y, width) %>"
              transform="<%= @view.rotate(angle, @settings.gauge_center) %>">
            </path>
          <% end %>
        </g>
      <% end %>

      <text class="value-font value-text"
        x="<%= elem(@settings.value_text.position, 0) %>" y = "<%= elem(@settings.value_text.position, 1) %>"
        text-anchor="middle" alignment-baseline="middle" dominant-baseline="central"
        ><%= @view.value(@data, @settings.value_text.decimals) %>
      </text>

    </svg>
    """
  end
end
