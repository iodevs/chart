defmodule Chart.Internal.Text do
  @moduledoc false

  alias Chart.Internal.{Utils, Validators}
  alias ExMaybe, as: Maybe

  defguard text_placement(pl)
           when pl in [:left, :center, :right, :top, :middle, :bottom] or is_tuple(pl)

  # @offset_bottom_title 20

  @type placement() :: :left | :center | :right | :top | :middle | :bottom | {number(), number()}
  @type turn() :: :on | :off

  @type t() :: %__MODULE__{
          gap: Maybe.t(number()),
          placement: Maybe.t(placement()),
          rect_bg: Maybe.t(turn()),
          show: Maybe.t(turn()),
          text: Maybe.t(String.t()),

          # Internal
          position: Maybe.t({number(), number()})
        }

  defstruct gap: nil,
            placement: nil,
            rect_bg: nil,
            show: nil,
            text: nil,

            # Internal
            position: nil

  def new() do
    %__MODULE__{
      gap: 0,
      placement: :center,
      rect_bg: :off,
      show: :on,
      text: "",
      position: {400, 50}
    }
  end

  def new(kw, validate \\ validate()) when is_list(kw) and is_map(validate) do
    Utils.update_module(new(), kw, validate)
  end

  # Private

  defp validate() do
    %{
      gap: {:gap, &Validators.validate_number/1},
      placement: {:placement, &Validators.validate_text_placement/1},
      rect_bg: {:rect_bg, &Validators.validate_turn/1},
      show: {:show, &Validators.validate_turn/1},
      text: {:text, &Validators.validate_string/1}
    }
  end
end
