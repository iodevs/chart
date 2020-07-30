defmodule Chart.Internal.Plot do
  @moduledoc false

  alias Chart.Internal.{Axis, TextPosition}

  @type t() :: %__MODULE__{
          # box: :on | :off,
          grid: nil | Grid.t(),
          position: nil | {number(), number()},
          size: nil | {number(), number()},
          x_axis: nil | Axis.t(),
          x_axis_label: nil | TextPosition.t(),
          y_axis: nil | Axis.t(),
          y_axis_label: nil | TextPosition.t(),
          viewbox: nil | {pos_integer(), pos_integer()}

          # Internal
        }

  defstruct grid: nil,
            # box: :off,
            plot_text: nil,
            position: nil,
            size: nil,
            x_axis: nil,
            x_axis_label: nil,
            y_axis: nil,
            y_axis_label: nil,
            viewbox: nil

  defmodule Grid do
    @moduledoc false

    @type placement() :: :bottom | :top

    @type t() :: %__MODULE__{
            major_gap: nil | number(),
            major_placement: nil | placement(),
            minor_gap: nil | number(),
            minor_placement: nil | placement()
          }

    defstruct major_gap: nil,
              major_placement: nil,
              minor_gap: nil,
              minor_placement: nil
  end
end
