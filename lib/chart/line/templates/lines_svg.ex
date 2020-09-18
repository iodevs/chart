defmodule Chart.Line.Templates.LinesSvg do
  @moduledoc false

  alias Chart.Line.Views.LinesView
  use Phoenix.HTML

  def render(_settings, data) when is_nil(data) or data == [] do
    ~E"""
    """
  end

  def render(settings, data) do
    ~E"""
    <g class="lines">
      <%= for {data, id_line} <- Enum.with_index(data) do %>
        <polyline id="line-<%= id_line %>" points="<%= LinesView.set_line_points(settings, data, settings.type) %>" />
      <% end %>
    </g>
    """
  end
end
