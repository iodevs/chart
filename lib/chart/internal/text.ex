defmodule Chart.Internal.Text do
  @moduledoc false

  alias Chart.Internal.{Utils, Validators}

  defguard text_placement(pl)
           when pl in [:left, :center, :right, :top, :middle, :bottom] or is_tuple(pl)

  # @offset_bottom_title 20

  @type placement() :: :left | :center | :right | :top | :middle | :bottom | {number(), number()}
  @type turn() :: :on | :off

  @type t() :: %__MODULE__{
          gap: nil | number(),
          placement: nil | placement(),
          rect_bg: turn(),
          text: nil | String.t(),

          # Internal
          position: nil | {number(), number()}
        }

  defstruct gap: nil,
            placement: nil,
            rect_bg: :off,
            text: nil,

            # Internal
            position: nil

  def new() do
    %__MODULE__{}
  end

  def put(text, :gap, config, default_value) do
    gap =
      Utils.key_guard(
        config,
        :text_gap,
        default_value,
        &Validators.validate_number/1
      )

    Map.put(text, :gap, gap)
  end

  def put(text, :placement, config, default_value) do
    placement =
      Utils.key_guard(
        config,
        :text_placement,
        default_value,
        &Validators.validate_text_placement/1
      )

    Map.put(text, :placement, placement)
  end

  def put(text, :rect_bg, config, default_value) do
    rect_bg =
      Utils.key_guard(
        config,
        :text_rect_bg,
        default_value,
        &Validators.validate_turn/1
      )

    Map.put(text, :rect_bg, rect_bg)
  end

  def put(text, :text, config, default_value) do
    new_text =
      Utils.key_guard(
        config,
        :text,
        default_value,
        &Validators.validate_string/1
      )

    Map.put(text, :text, new_text)
  end

  # Private
end
