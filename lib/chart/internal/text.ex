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
          show: turn(),
          text: nil | String.t(),

          # Internal
          position: nil | {number(), number()}
        }

  defstruct gap: nil,
            placement: nil,
            rect_bg: :off,
            show: :on,
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

  def put(text, key, config_key, config) do
    Utils.put(text, key, config_key, config, &validate/0)
  end

  def set(text, key, value) do
    Map.put(text, key, value)
  end

  # Private

  defp validate() do
    %{
      gap: &Validators.validate_number/1,
      placement: &Validators.validate_text_placement/1,
      rect_bg: &Validators.validate_turn/1,
      show: &Validators.validate_turn/1,
      text: &Validators.validate_string/1
    }
  end
end
