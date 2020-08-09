defmodule Chart.Internal.Text do
  @moduledoc false

  alias Chart.Internal.{Utils, Validators}
  alias ExMaybe, as: Maybe

  @type position() :: {number(), number()}
  @type turn() :: :on | :off

  @type t() :: %__MODULE__{
          gap: Maybe.t(number()),
          position: Maybe.t(position()),
          rect_bg: Maybe.t(turn()),
          show: Maybe.t(turn()),
          text: Maybe.t(String.t())
        }

  defstruct gap: nil,
            position: nil,
            rect_bg: nil,
            show: nil,
            text: nil

  def new() do
    %__MODULE__{
      gap: 0,
      position: {0, 0},
      rect_bg: :off,
      show: :on,
      text: ""
    }
  end

  def new(kw, validators \\ validators()) when is_list(kw) and is_map(validators) do
    Utils.merge(new(), kw, validators)
  end

  def put(module, key, value, validators \\ validators()) do
    Utils.put(module, key, value, validators)
  end

  def set(module, key, value) do
    Map.put(module, key, value)
  end

  def validators() do
    %{
      gap: {:gap, &Validators.validate_number/1},
      position: {:position, &Validators.validate_position/1},
      rect_bg: {:rect_bg, &Validators.validate_turn/1},
      show: {:show, &Validators.validate_turn/1},
      text: {:text, &Validators.validate_string/1}
    }
  end
end
