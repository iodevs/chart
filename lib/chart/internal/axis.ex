defmodule Chart.Internal.Axis do
  @moduledoc false

  alias Chart.Internal.{MajorTicks, MinorTicks, MajorTicksText, TextPosition}

  defguard origin_cs(cs)
           when cs in [
                  :left_bottom,
                  :center_bottom,
                  :right_bottom,
                  :left_top,
                  :center_top,
                  :right_top,
                  :center
                ] or is_tuple(cs)

  @type origin_cs() ::
          :left_bottom
          | :center_bottom
          | :right_bottom
          | :left_top
          | :center_top
          | :right_top
          | :center
          | {number(), number()}
  @type scale() :: :linear | :log

  @type t() :: %__MODULE__{
          label: nil | String.t(),
          major_ticks: nil | MajorTicks.t(),
          minor_ticks: nil | MinorTicks.t(),
          major_ticks_text: nil | MajorTicksText.t(),
          origin_cs: nil | origin_cs(),
          scale: nil | scale(),
          thickness: nil | number,

          # Internal
          length: nil | number(),
          position: nil | {pos_integer(), pos_integer()}
        }

  defstruct label: nil,
            major_ticks: nil,
            minor_ticks: nil,
            major_ticks_text: nil,
            origin_cs: nil,
            scale: nil,
            thickness: nil,

            # Internal
            length: nil,
            position: nil

  defmodule MajorTicks do
    @moduledoc false

    alias Chart.Internal.{Utils, Validators}

    @type t() :: %__MODULE__{
            count: pos_integer(),
            gap: number(),
            length: number(),

            # Internal
            positions: list(tuple())
          }

    defstruct count: 0,
              gap: 0,
              length: 0,
              positions: []

    def put(plot, config) do
      plot
    end

    # Private
  end

  defmodule MinorTicks do
    @moduledoc false

    alias Chart.Internal.{Utils, Validators}

    @type t() :: %__MODULE__{
            count: pos_integer(),
            gap: number(),
            length: number(),

            # Internal
            positions: list(),
            translate: String.t()
          }

    defstruct count: 0,
              gap: 0,
              length: 0,
              positions: [],
              translate: ""

    def put(plot, config) do
      plot
    end

    # Private
  end

  defmodule MajorTicksText do
    @moduledoc false

    alias Chart.Internal.{Utils, Validators}

    @offset_radius_text 15

    @type t() :: %__MODULE__{
            decimals: nil | non_neg_integer(),
            gap: nil | number(),

            # Internal
            positions: nil | list()
          }

    defstruct decimals: nil,
              gap: nil,
              positions: nil

    def put(plot, config) do
      plot
    end

    # Private
  end
end
