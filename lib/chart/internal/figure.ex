defmodule Chart.Internal.Figure do
  @moduledoc false

  @fig_viewbox {800, 600}

  def new() do
    %{viewbox: @fig_viewbox}
  end

  def add(settings) when is_map(settings) do
    Map.put(settings, :figure, new())
  end

  def put_viewbox(settings, {width, height} = viewbox)
      when is_number(width) and is_number(height) and 0 < width and 0 < height do
    put_in(settings, [:figure, :viewbox], viewbox)
  end
end
