defmodule Chart.Internal.Axis do
  @moduledoc false

  alias Chart.Internal.{MajorTicks, MinorTicks, MajorTicksText, Text, Utils, Validators}

  defguard scale(s) when s in [:linear, :log]

  @type scale() :: :linear | :log

  @type t() :: %__MODULE__{
          label: nil | Text.t(),
          major_ticks: nil | MajorTicks.t(),
          minor_ticks: nil | MinorTicks.t(),
          major_ticks_text: nil | MajorTicksText.t(),
          scale: nil | scale(),
          thickness: nil | number(),

          # Internal
          line: nil | {pos_integer(), pos_integer(), pos_integer(), pos_integer()}
        }

  defstruct label: nil,
            major_ticks: nil,
            minor_ticks: nil,
            major_ticks_text: nil,
            scale: nil,
            thickness: nil,

            # Internal
            line: nil

  @spec new() :: Axis.t()
  def new() do
    %__MODULE__{
      label: nil,
      major_ticks: nil,
      minor_ticks: nil,
      major_ticks_text: nil,
      scale: :linear,
      thickness: 2,
      line: nil
    }
  end

  def put(axis, key, config_key, config) do
    Utils.put(axis, key, config_key, config, &validate/0)
  end

  # Private

  defp validate() do
    %{
      scale: &Validators.validate_axis_scale/1,
      thickness: &Validators.validate_positive_number/1
    }
  end

  defmodule MajorTicks do
    @moduledoc false

    alias Chart.Internal.{Utils, Validators}

    @type t() :: %__MODULE__{
            count: nil | pos_integer(),
            gap: nil | number(),
            length: nil | number(),
            range: nil | {number(), number()},

            # Internal
            positions: nil | list(number())
          }

    defstruct count: nil,
              gap: nil,
              length: nil,
              range: nil,

              # Internal
              positions: nil

    def new() do
      %__MODULE__{
        count: 7,
        gap: 0,
        length: 0.5,
        range: {0, 1},
        positions: []
      }
    end

    def put(major_ticks, key, config_key, config) do
      Utils.put(major_ticks, key, config_key, config, &validate/0)
    end

    def set(major_ticks, key, :linear) do
      lst = Utils.linspace(major_ticks.range, major_ticks.count)

      Map.put(major_ticks, key, lst)
    end

    def set(major_ticks, key, :log) do
      lst = Utils.logspace(major_ticks.range, major_ticks.count)

      Map.put(major_ticks, key, lst)
    end

    def set(major_ticks, key, value) do
      Map.put(major_ticks, key, value)
    end

    # Private

    defp validate() do
      %{
        count: &Validators.validate_ticks_count/1,
        gap: &Validators.validate_number/1,
        length: &Validators.validate_positive_number/1,
        range: &Validators.validate_range/1
      }
    end
  end

  defmodule MinorTicks do
    @moduledoc false

    alias Chart.Internal.{Utils, Validators}

    @type t() :: %__MODULE__{
            count: nil | pos_integer(),
            gap: nil | number(),
            length: nil | number(),
            range: nil | {number(), number()},

            # Internal
            positions: nil | list(number())
          }

    defstruct count: nil,
              gap: nil,
              length: nil,
              range: nil,

              #  Internal
              positions: nil

    def new() do
      %__MODULE__{
        count: 20,
        gap: 0,
        length: 0.25,
        range: {0, 1},
        positions: []
      }
    end

    def put(minor_ticks, key, config_key, config) do
      Utils.put(minor_ticks, key, config_key, config, &validate/0)
    end

    def set(minor_ticks, key, :linear) do
      lst = Utils.linspace(minor_ticks.range, minor_ticks.count)

      Map.put(minor_ticks, key, lst)
    end

    def set(minor_ticks, key, :log) do
      lst = Utils.logspace(minor_ticks.range, minor_ticks.count)

      Map.put(minor_ticks, key, lst)
    end

    def set(minor_ticks, key, value) do
      Map.put(minor_ticks, key, value)
    end

    # Private

    defp validate() do
      %{
        count: &Validators.validate_ticks_count/1,
        gap: &Validators.validate_number/1,
        length: &Validators.validate_positive_number/1,
        range: &Validators.validate_range/1
      }
    end
  end

  defmodule MajorTicksText do
    @moduledoc false

    alias Chart.Internal.{Utils, Validators}

    @type format() :: {:decimals, non_neg_integer()} | {:datetime, String.t()}

    @type t() :: %__MODULE__{
            format: nil | format(),
            gap: nil | number(),
            labels: nil | list(String.t()),

            # Internal
            positions: nil | list(number())
          }

    defstruct format: nil,
              gap: nil,
              labels: nil,
              positions: nil

    def new() do
      %__MODULE__{
        format: {:decimals, 0},
        gap: 0,
        labels: [],
        positions: []
      }
    end

    def put(minor_ticks, key, config_key, config) do
      Utils.put(minor_ticks, key, config_key, config, &validate/0)
    end

    def set(major_ticks_text, key, value) do
      Map.put(major_ticks_text, key, value)
    end

    # Private

    defp validate() do
      %{
        format: &Validators.validate_axis_tick_labels_format/1,
        gap: &Validators.validate_number/1,
        labels: &Validators.validate_labels/1
      }
    end
  end
end
