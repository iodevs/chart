defmodule Chart.Line.Templates.AxisSvg do
  @moduledoc false

  alias Chart.Line.Views.AxisView
  alias Chart.Internal.Utils
  use Phoenix.HTML

  def render(settings) do
    x_axis = Utils.get_axis_for_vector(settings.axis_table, {1, 0})
    y_axis = Utils.get_axis_for_vector(settings.axis_table, {0, 1})

    assigns =
      %{}
      |> Map.put(:x_axis_major_ticks, ticks_render(settings, [x_axis, :line, :major_ticks]))
      |> Map.put(:y_axis_major_ticks, ticks_render(settings, [y_axis, :line, :major_ticks]))
      |> Map.put(:x_axis_minor_ticks, ticks_render(settings, [x_axis, :line, :minor_ticks]))
      |> Map.put(:y_axis_minor_ticks, ticks_render(settings, [y_axis, :line, :minor_ticks]))
      |> Map.put(
        :x_axis_major_ticks_text,
        ticks_text_render(settings, [x_axis, :line, :major_ticks_text])
      )
      |> Map.put(
        :y_axis_major_ticks_text,
        ticks_text_render(settings, [y_axis, :line, :major_ticks_text])
      )
      |> Map.put(:x_axis, axis_render(settings, [x_axis, :line, :thickness]))
      |> Map.put(:y_axis, axis_render(settings, [y_axis, :line, :thickness]))
      |> Map.put(:x_axis_label, label_render(settings[x_axis], [x_axis, :label]))
      |> Map.put(:y_axis_label, label_render(settings[y_axis], [y_axis, :label]))

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

  defp ticks_render(settings, [_axis, _line, ticks_type])
       when not is_map_key(settings, ticks_type) do
    ~E"""
    """
  end

  defp ticks_render(settings, [axis, line, ticks_type]) do
    ticks = settings[axis][ticks_type]
    vector = settings[:axis_table][axis]
    {x1, y1} = AxisView.set_axis_tick(ticks.length, vector)

    assigns =
      ticks
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
          transform="<%= AxisView.translate_axis_ticks(settings[axis][line], ticks.length, ticks.gap, position, vector) %>" />
      <% end %>
    </g>
    """
  end

  defp ticks_text_render(settings, [_axis, _line, ticks_text_type])
       when not is_map_key(settings, ticks_text_type) do
    ~E"""
    """
  end

  defp ticks_text_render(settings, [axis, line, ticks_text_type]) do
    ticks_text = settings[axis][ticks_text_type]
    vector = settings[:axis_table][axis]

    assigns =
      ticks_text
      |> Map.put(:css_tick_label, AxisView.css_class_axis_tick_label(axis))
      |> Map.put(:css_ticks_label, AxisView.css_class_axis_major_ticks_label(axis))
      |> Map.put(:ticks_label, AxisView.axis_ticks_label(line, ticks_text, vector))

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

  defp axis_render(settings, [axis, line, thickness]) do
    vector = settings[:axis_table][axis]

    {x1, y1, x2, y2, thickness} =
      AxisView.set_axis_line(settings[axis][line], settings[axis][thickness], vector)

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
