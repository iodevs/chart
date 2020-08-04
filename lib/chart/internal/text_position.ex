defmodule Chart.Internal.TextPosition do
  @moduledoc false

  alias Chart.Internal.{Figure, Plot, Utils, Validators}

  defguard text_position(pos)
           when pos in [:left, :center, :right, :top, :middle, :bottom] or is_tuple(pos)

  # @offset_bottom_title 20

  @type position() :: :left | :center | :right | :top | :middle | :bottom | {number(), number()}
  @type turn() :: :on | :off

  @type t() :: %__MODULE__{
          gap: nil | number(),
          position: nil | position(),
          rect_bg: turn(),
          text: nil | String.t()
        }

  defstruct gap: nil,
            position: nil,
            rect_bg: :off,
            text: nil

  def put(%Figure{} = figure, _config) do
    figure
  end

  def put(%Plot{} = plot, _config) do
    plot
  end

  # Private
end
