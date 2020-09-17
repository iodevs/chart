defmodule Chart.Line.Templates.TitleSvg do
  @moduledoc false

  use Phoenix.HTML

  def render(%{title: %{position: {x, y}, text: text}})
      when 0 < byte_size(text) do
    assigns =
      %{}
      |> Map.put(:text, text)
      |> Map.put(:x, x)
      |> Map.put(:y, y)

    ~E"""
    <text id="title" x="<%= @x %>" y="<%= @y %>" alignment-baseline="middle" text-anchor="middle" ><%= @text %></text>
    """
  end

  def render(_settings) do
    ~E"""
    """
  end
end
