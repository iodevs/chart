defmodule Chart.Internal.Figure do
  @moduledoc false

  import Chart.Internal.Guards, only: [is_positive_number: 2]

  def new() do
    %{viewbox: {800, 600}}
  end

  def add(settings) when is_map(settings) do
    Map.put(settings, :figure, new())
  end

  def put_viewbox(settings, {width, height} = viewbox) when is_positive_number(width, height) do
    put_in(settings, [:figure, :viewbox], viewbox)
  end
end
