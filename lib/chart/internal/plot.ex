defmodule Chart.Internal.Plot do
  @moduledoc false

  alias Chart.Internal.{Axis, Text, Utils, Validators}
  alias Chart.Internal.Axis.{MajorTicks, MinorTicks, MajorTicksText}
  alias ExMaybe, as: Maybe

  # defguard origin_cs(cs)
  #          when cs in [
  #                 :left_bottom,
  #                 :center_bottom,
  #                 :right_bottom,
  #                 :left_top,
  #                 :center_top,
  #                 :right_top,
  #                 :center
  #               ] or is_tuple(cs)

  # @type origin_cs() ::
  #         :left_bottom
  #         | :center_bottom
  #         | :right_bottom
  #         | :left_top
  #         | :center_top
  #         | :right_top
  #         | :center
  #         | {number(), number()}

  @type t() :: %__MODULE__{
          # box: :on | :off,
          grid: Maybe.t(Grid.t()),
          position: Maybe.t({number(), number()}),
          # origin_cs: Maybe.t(origin_cs()),
          rect_bg_padding: Maybe.t({number(), number(), number(), number()}),
          size: Maybe.t({number(), number()}),
          x_axis: Maybe.t(Axis.t()),
          y_axis: Maybe.t(Axis.t())
          # viewbox: Maybe.t({pos_integer(), pos_integer()})

          # Internal
        }

  defstruct grid: nil,
            # box: :off,
            position: nil,
            rect_bg_padding: nil,
            size: nil,
            x_axis: nil,
            y_axis: nil

  defmodule Grid do
    @moduledoc false

    alias ExMaybe, as: Maybe

    defguard grid_placement(grid) when grid in [:under, :over]

    @type turn() :: :on | :off
    @type placement() :: :under | :over

    @type t() :: %__MODULE__{
            major_gap: Maybe.t(number()),
            major_placement: Maybe.t(placement()),
            major_turn: Maybe.t(turn()),
            minor_gap: Maybe.t(number()),
            minor_placement: Maybe.t(placement()),
            minor_turn: Maybe.t(turn())
          }

    defstruct major_gap: nil,
              major_placement: nil,
              major_turn: nil,
              minor_gap: nil,
              minor_placement: nil,
              minor_turn: nil

    def new() do
      %__MODULE__{
        major_gap: 0.5,
        major_placement: :under,
        major_turn: :on,
        minor_gap: 0.5,
        minor_placement: :under,
        minor_turn: :off
      }
    end

    def new(kw, validate \\ validate()) when is_list(kw) and is_map(validate) do
      Utils.update_module(new(), kw, validate)
    end

    # Private

    defp validate() do
      %{
        major_gap: {:major_gap, &Validators.validate_positive_number/1},
        major_placement: {:major_placement, &Validators.validate_grid_placement/1},
        major_turn: {:major_turn, &Validators.validate_turn/1},
        minor_gap: {:minor_gap, &Validators.validate_positive_number/1},
        minor_placement: {:minor_placement, &Validators.validate_grid_placement/1},
        minor_turn: {:minor_turn, &Validators.validate_turn/1}
      }
    end
  end

  def new() do
    %__MODULE__{
      grid: nil,
      # box: :off,
      position: {100, 100},
      rect_bg_padding: {0, 0, 0, 0},
      size: {600, 400},
      x_axis: nil,
      y_axis: nil
    }
  end

  def new(kw, validate) when is_list(kw) and is_map(validate) do
    Utils.update_module(new(), kw, validate)
  end
end
