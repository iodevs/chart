defmodule Chart.Bar.Templates.BarsSvg do
  @moduledoc false

  alias Chart.Bar.Views.BarsView
  use Phoenix.HTML

  def render(_settings, data) when is_map(data) or data == %{} do
    ~E"""
    """
  end

  def render(settings, data) do
    assigns = settings

    ~E"""
    <g class="bars">
      <%= for {key, value} <- data do %>
      <rect class="ha" x="20" y="30" height="420" rx="0" style="fill:rgb(0,0,255);stroke-width:3;stroke:rgb(0,0,0)" />

      <rect class="ha" x="140" y="230" height="220" rx="0" style="fill:rgb(0,255,255);stroke-width:3;stroke:rgb(0,0,0)" />

      <rect class="ha c3" x="260" y="350" height="100" rx="0" style="stroke-width:3;stroke:rgb(0,0,0)" />
      <% end %>
    </g>
    """
  end
end
