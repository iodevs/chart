defmodule Chart.Internal.Plot do
  @moduledoc false

  def new() do
    %{
      position: {100, 100},
      rect_bg_padding: {0, 0, 0, 0},
      size: {600, 400}
    }
  end

  def add(settings) when is_map(settings) do
    Map.put(settings, :plot, new())
  end

  # defp validate() do
  #   %{
  #     position:
  #       {:plot_position, &Validators.validate_plot_size(&1, {@fig_viewbox, %Plot{}.size})},
  #     rect_bg_padding: {:plot_bg_padding, &Validators.validate_rect_bg_padding/1},
  #     size: {:plot_size, &Validators.validate_plot_size(&1, @fig_viewbox)}
  #   }
  # end
end
