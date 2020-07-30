defmodule Chart.Internal.Axis do
  @moduledoc false

  alias Chart.Internal.{MajorTicks, MinorTicks, MajorTicksText, TextPosition}

  @type scale() :: :linear | :log

  @type t() :: %__MODULE__{
          label: nil | String.t(),
          major_ticks: nil | MajorTicks.t(),
          minor_ticks: nil | MinorTicks.t(),
          major_ticks_text: nil | MajorTicksText.t(),
          position_label: nil | TextPosition.t(),
          scale: nil | scale(),

          # Internal
          lenght: nil | number(),
          position: nil | {pos_integer(), pos_integer()}
        }

  defstruct label: nil,
            major_ticks: nil,
            minor_ticks: nil,
            major_ticks_text: nil,
            position_label: nil,
            scale: nil,

            # Internal
            lenght: nil,
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

    def put(axis, config) do
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

    def put(settings, config) do
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

    def put(settings, config) do
    end

    # Private
  end
end
