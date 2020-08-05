defmodule Chart.Internal.TextPosition do
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

  def put(config, default) do
    %__MODULE__{
      gap:
        Utils.key_guard(
          config,
          :text_gap,
          default.text_gap,
          &Validators.validate_number/1
        ),
      placement:
        Utils.key_guard(
          config,
          :text_position,
          default.text_position,
          &Validators.validate_text_placement/1
        ),
      rect_bg:
        Utils.key_guard(
          config,
          :text_rect_bg,
          default.text_rect_bg,
          &Validators.validate_turn/1
        ),
      text:
        Utils.key_guard(
          config,
          :text,
          default.text,
          &Validators.validate_string/1
        )
    }
  end

  # Private
end
