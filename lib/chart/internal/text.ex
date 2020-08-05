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
    %__MODULE__{
      gap: 0,
      placement: nil,
      rect_bg: :off,
      text: nil
    }
  end

  def put(text, key, config) do
    Utils.put(text, key, config, &lookup/1)
  end

  # Private

  defp lookup(key) do
    %{
      gap: {:text_gap, &Validators.validate_number/1},
      placement: {:text_placement, &Validators.validate_text_placement/1},
      rect_bg: {:text_rect_bg, &Validators.validate_turn/1},
      text: {:text, &Validators.validate_string/1}
    }
    |> Map.fetch!(key)
  end
end
