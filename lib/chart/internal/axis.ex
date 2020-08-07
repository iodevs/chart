defmodule Chart.Internal.Axis do
  @moduledoc false

  alias Chart.Internal.{MajorTicks, MinorTicks, MajorTicksText, Text, Utils, Validators}
  alias ExMaybe, as: Maybe

  defguard scale(s) when s in [:linear, :log]

  @type scale() :: :linear | :log

  @type t() :: %__MODULE__{
          label: Maybe.t(Text.t()),
          major_ticks: Maybe.t(MajorTicks.t()),
          minor_ticks: Maybe.t(MinorTicks.t()),
          major_ticks_text: Maybe.t(MajorTicksText.t()),
          scale: Maybe.t(scale()),
          thickness: Maybe.t(number()),

          # Internal
          line: Maybe.t({pos_integer(), pos_integer(), pos_integer(), pos_integer()})
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

  def new(kw, validate \\ validate()) when is_list(kw) and is_map(validate) do
    Utils.update_module(new(), kw, validate)
  end

  def set(axis, key, value) do
    Map.put(axis, key, value)
  end

  # Private

  defp validate() do
    %{
      scale: {:scale, &Validators.validate_axis_scale/1},
      thickness: {:thickness, &Validators.validate_positive_number/1}
    }
  end

  defmodule MajorTicks do
    @moduledoc false

    alias Chart.Internal.{Utils, Validators}
    alias ExMaybe, as: Maybe

    @type t() :: %__MODULE__{
            count: Maybe.t(pos_integer()),
            gap: Maybe.t(number()),
            length: Maybe.t(number()),
            range: Maybe.t({number(), number()}),

            # Internal
            positions: Maybe.t(list(number()))
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

    def new(kw, validate \\ validate()) when is_list(kw) and is_map(validate) do
      Utils.update_module(new(), kw, validate)
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
        count: {:count, &Validators.validate_ticks_count/1},
        gap: {:gap, &Validators.validate_number/1},
        length: {:length, &Validators.validate_positive_number/1},
        range: {:range, &Validators.validate_range/1}
      }
    end
  end

  defmodule MinorTicks do
    @moduledoc false

    alias Chart.Internal.{Utils, Validators}
    alias ExMaybe, as: Maybe

    @type t() :: %__MODULE__{
            count: Maybe.t(pos_integer()),
            gap: Maybe.t(number()),
            length: Maybe.t(number()),
            range: Maybe.t({number(), number()}),

            # Internal
            positions: Maybe.t(list(number()))
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

    def new(kw, validate \\ validate()) when is_list(kw) and is_map(validate) do
      Utils.update_module(new(), kw, validate)
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
        count: {:count, &Validators.validate_ticks_count/1},
        gap: {:gap, &Validators.validate_number/1},
        length: {:length, &Validators.validate_positive_number/1},
        range: {:range, &Validators.validate_range/1}
      }
    end
  end

  defmodule MajorTicksText do
    @moduledoc false

    alias Chart.Internal.{Utils, Validators}
    alias ExMaybe, as: Maybe

    @type format() :: {:decimals, non_neg_integer()} | {:datetime, String.t()}

    @type t() :: %__MODULE__{
            format: Maybe.t(format()),
            gap: Maybe.t(number()),
            labels: Maybe.t(list(String.t())),

            # Internal
            positions: Maybe.t(list(number()))
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

    def new(kw, validate \\ validate()) when is_list(kw) and is_map(validate) do
      Utils.update_module(new(), kw, validate)
    end

    def set(major_ticks_text, key, value) do
      Map.put(major_ticks_text, key, value)
    end

    # Private

    defp validate() do
      %{
        format: {:format, &Validators.validate_axis_tick_labels_format/1},
        gap: {:gap, &Validators.validate_number/1},
        labels: {:labels, &Validators.validate_labels/1}
      }
    end
  end
end
