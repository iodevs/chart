defmodule Chart.Bar.Templates.BarsSvg do
  @moduledoc false

  alias Chart.Bar.Views.BarsView
  use Phoenix.HTML

  def render(_settings, nil) do
    ~E"""
    """
  end

  def render(%{bar: bar, x_axis: x_axis, y_axis: y_axis}, data) when is_list(data) do
    assigns =
      %{}
      |> Map.put(
        :rect_data,
        BarsView.calc_rect_attributes(
          Enum.map(data, fn {_k, v} -> v end),
          x_axis.major_ticks.positions,
          y_axis.major_ticks_text.range,
          y_axis.line,
          bar.width
        )
      )

    ~E"""
    <g class="bars">
      <%= for {{x, y, w, h}, id_bar} <- Enum.with_index(@rect_data) do %>
        <rect id="bar-<%= id_bar %>" x="<%= x %>" y="<%= y %>" width="<%= w %>" height="<%= h %>" />
      <% end %>
    </g>
    """
  end
end
