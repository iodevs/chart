defmodule Chart.Line.Templates.AxisSvg do
  @moduledoc false

  alias Chart.Line.Views.AxisView
  alias Chart.Internal.Utils
  use Phoenix.HTML

  def render(settings) do
    axis_table = settings.axis_table
    x_axis = Utils.get_axis_for_vector(axis_table, {1, 0})
    y_axis = Utils.get_axis_for_vector(axis_table, {0, 1})
    x_axis_map = settings[x_axis]
    y_axis_map = settings[y_axis]

    assigns =
      %{}
      |> Map.put(
        :x_axis_major_ticks,
        ticks_render(x_axis_map, axis_table, [x_axis, :line, :major_ticks])
      )
      |> Map.put(
        :y_axis_major_ticks,
        ticks_render(y_axis_map, axis_table, [y_axis, :line, :major_ticks])
      )
      |> Map.put(
        :x_axis_minor_ticks,
        ticks_render(x_axis_map, axis_table, [x_axis, :line, :minor_ticks])
      )
      |> Map.put(
        :y_axis_minor_ticks,
        ticks_render(y_axis_map, axis_table, [y_axis, :line, :minor_ticks])
      )
      |> Map.put(
        :x_axis_major_ticks_text,
        ticks_text_render(x_axis_map, axis_table, [x_axis, :line, :major_ticks_text])
      )
      |> Map.put(
        :y_axis_major_ticks_text,
        ticks_text_render(y_axis_map, axis_table, [y_axis, :line, :major_ticks_text])
      )
      |> Map.put(:x_axis, axis_render(x_axis_map, axis_table, [x_axis, :line, :thickness]))
      |> Map.put(:y_axis, axis_render(y_axis_map, axis_table, [y_axis, :line, :thickness]))
      |> Map.put(:x_axis_label, label_render(x_axis_map, [x_axis, :label]))
      |> Map.put(:y_axis_label, label_render(y_axis_map, [y_axis, :label]))

    ~E"""
    <g class="axis">
      <%= @y_axis_minor_ticks %>
      <%= @y_axis_major_ticks %>
      <%= @y_axis_major_ticks_text %>
      <%= @y_axis %>
      <%= @y_axis_label %>
      <%= @x_axis_minor_ticks %>
      <%= @x_axis_major_ticks %>
      <%= @x_axis_major_ticks_text %>
      <%= @x_axis %>
      <%= @x_axis_label %>
    </g>
    """
  end

  # Private

  defp ticks_render(axis_map, _axis_table, [_axis, _line, ticks_type])
       when not is_map_key(axis_map, ticks_type) do
    ~E"""
    """
  end

  defp ticks_render(axis_map, axis_table, [axis, line, ticks_type]) do
    ticks = axis_map[ticks_type]
    vector = axis_table[axis]
    {x1, y1} = AxisView.set_axis_tick(ticks.length, vector)

    assigns =
      %{}
      |> Map.put(:css_id, AxisView.css_id_axis_ticks_line(axis, ticks_type))
      |> Map.put(:css_class, AxisView.css_class_axis_ticks(axis, ticks_type))
      |> Map.put(:x1, x1)
      |> Map.put(:y1, y1)

    ~E"""
    <defs>
      <line id="<%= @css_id %>" x1="<%= @x1 %>" y1="<%= @y1 %>" />
    </defs>
    <g class="<%= @css_class %>">
      <%= for position <- ticks.positions do %>
        <use xlink:href="#<%= @css_id %>"
          transform="<%= AxisView.translate_axis_ticks(axis_map[line], ticks.length, ticks.gap, position, vector) %>" />
      <% end %>
    </g>
    """
  end

  defp ticks_text_render(axis_map, _axis_table, [_axis, _line, ticks_text_type])
       when not is_map_key(axis_map, ticks_text_type) do
    ~E"""
    """
  end

  defp ticks_text_render(axis_map, axis_table, [axis, line, ticks_text_type]) do
    ticks_text = axis_map[ticks_text_type]
    vector = axis_table[axis]

    assigns =
      %{}
      |> Map.put(:css_tick_label, AxisView.css_class_axis_tick_label(axis))
      |> Map.put(:css_ticks_label, AxisView.css_class_axis_major_ticks_label(axis))
      |> Map.put(:ticks_label, AxisView.axis_ticks_label(axis_map[line], ticks_text, vector))

    ~E"""
    <g class="<%= @css_ticks_label %>">
      <%= for {pos_x, pos_y, label} <- @ticks_label do %>
        <text class="<%= @css_tick_label %>" x="<%= pos_x %>" y="<%= pos_y %>"
          alignment-baseline="middle" text-anchor="middle"
        ><%= label %></text>
      <% end %>
    </g>
    """
  end

  defp axis_render(axis_map, axis_table, [axis, line, thickness]) do
    {x1, y1, x2, y2, thickness} =
      AxisView.set_axis_line(axis_map[line], axis_map[thickness], axis_table[axis])

    assigns =
      %{}
      |> Map.put(:thickness, thickness)
      |> Map.put(:x1, x1)
      |> Map.put(:y1, y1)
      |> Map.put(:x2, x2)
      |> Map.put(:y2, y2)

    ~E"""
    <line id="<%= Atom.to_string(axis) %>" x1="<%= @x1 %>" y1="<%= @y1 %>" x2="<%= @x2 %>" y2="<%= @y2 %>"
      stroke-width="<%= @thickness %>" />
    """
  end

  defp label_render(axis_map, [_axis, label])
       when not is_map_key(axis_map, label) do
    ~E"""
    """
  end

  defp label_render(axis_map, [axis, label]) do
    label = axis_map[label]
    {pos_x, pos_y} = label.position

    assigns =
      %{}
      |> Map.put(:css_id, AxisView.css_id_axis_label(axis))
      |> Map.put(:text, label.text)
      |> Map.put(:pos_x, pos_x)
      |> Map.put(:pos_y, pos_y)

    ~E"""
    <g class="axis-label">
      <text id="<%= @css_id %>" x="<%= @pos_x %>" y="<%= @pos_y %>" dominant-baseline="central"
        text-anchor="middle"><%= @text %></text>
    </g>
    """
  end
end
