defmodule Chart.Internal.Text do
  @moduledoc false

  defguard text_placement(pl)
           when pl in [:left, :center, :right, :top, :middle, :bottom] or is_tuple(pl)

  # @offset_bottom_title 20

  # @type placement() :: :left | :center | :right | :top | :middle | :bottom | {number(), number()}
  # @type turn() :: :on | :off

  def new() do
    %{
      gap: 0,
      placement: :center,
      rect_bg: :off,
      show: :on,
      text: "",
      position: {400, 50}
    }
  end
end
