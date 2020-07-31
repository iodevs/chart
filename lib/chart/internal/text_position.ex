defmodule Chart.Internal.TextPosition do
  @moduledoc false

  alias Chart.Internal.{Figure, Plot, Utils, Validators}

  defguard text_position(pos) when pos in [:left, :center, :right]

  @offset_bottom_title 20

  @type position() :: {number(), number()} | :left | :center | :right

  @type t() :: %__MODULE__{
          gap: number(),
          position: nil | position(),
          subtitle: nil | String.t(),
          title: nil | String.t()
        }

  defstruct gap: nil,
            position: nil,
            subtitle: nil,
            title: nil

  def put(%Figure{} = figure, _config) do
    figure
  end

  def put(%Plot{} = plot, _config) do
    plot
  end

  # Private
end
