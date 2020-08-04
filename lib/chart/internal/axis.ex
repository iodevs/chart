defmodule Chart.Internal.Axis do
  @moduledoc false

  alias Chart.Internal.{MajorTicks, MinorTicks, MajorTicksText, TextPosition, Utils, Validators}

  defguard scale(s) when s in [:linear, :log]

  @type scale() :: :linear | :log

  @type t() :: %__MODULE__{
          label: nil | TextPosition.t(),
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

  defmodule MajorTicks do
    @moduledoc false

    alias Chart.Internal.{Utils, Validators}

    @type t() :: %__MODULE__{
            count: pos_integer(),
            gap: number(),
            length: number(),
            range: {number(), number()},

            # Internal
            positions: list(number())
          }

    defstruct count: 0,
              gap: 0,
              length: 0,
              range: {0, 1},

              # Internal
              positions: []

    def put(axis, config, default) do
      major_ticks =
        %__MODULE__{
          count:
            Utils.key_guard(
              config,
              :major_ticks_count,
              default.major_ticks_count,
              &Validators.validate_ticks_count/1
            ),
          gap:
            Utils.key_guard(
              config,
              :major_ticks_gap,
              default.major_ticks_gap,
              &Validators.validate_number/1
            ),
          length:
            Utils.key_guard(
              config,
              :major_ticks_length,
              default.major_ticks_length,
              &Validators.validate_positive_number/1
            ),
          range:
            Utils.key_guard(
              config,
              :major_ticks_range,
              default.major_ticks_range,
              &Validators.validate_range/1
            )
        }
        |> set_positions(default.scale)

      Kernel.put_in(axis.major_ticks, major_ticks)
    end

    # Private

    defp set_positions(major_ticks, :linear) do
      lst = Utils.linspace(major_ticks.range, major_ticks.count)

      Map.put(major_ticks, :positions, lst)
    end

    defp set_positions(major_ticks, :log) do
      lst = Utils.logspace(major_ticks.range, major_ticks.count)

      Map.put(major_ticks, :positions, lst)
    end
  end

  defmodule MinorTicks do
    @moduledoc false

    alias Chart.Internal.{Utils, Validators}

    @type t() :: %__MODULE__{
            count: pos_integer(),
            gap: number(),
            length: number(),
            range: {number(), number()},

            # Internal
            positions: list(number())
          }

    defstruct count: 0,
              gap: 0,
              length: 0,
              range: {0, 1},

              #  Internal
              positions: []

    def put(axis, config, default) do
      minor_ticks =
        %__MODULE__{
          count:
            Utils.key_guard(
              config,
              :minor_ticks_count,
              default.minor_ticks_count,
              &Validators.validate_ticks_count/1
            ),
          gap:
            Utils.key_guard(
              config,
              :minor_ticks_gap,
              default.minor_ticks_gap,
              &Validators.validate_number/1
            ),
          length:
            Utils.key_guard(
              config,
              :minor_ticks_length,
              default.minor_ticks_length,
              &Validators.validate_positive_number/1
            ),
          range:
            Utils.key_guard(
              config,
              :minor_ticks_range,
              default.minor_ticks_range,
              &Validators.validate_range/1
            )
        }
        |> set_positions(default.scale)

      Kernel.put_in(axis.minor_ticks, minor_ticks)
    end

    # Private

    defp set_positions(minor_ticks, :linear) do
      lst = Utils.linspace(minor_ticks.range, minor_ticks.count)

      Map.put(minor_ticks, :positions, lst)
    end

    defp set_positions(minor_ticks, :log) do
      lst = Utils.logspace(minor_ticks.range, minor_ticks.count)

      Map.put(minor_ticks, :positions, lst)
    end
  end

  defmodule MajorTicksText do
    @moduledoc false

    alias Chart.Internal.{Utils, Validators}

    @type format() :: {:decimals, non_neg_integer()} | {:datetime, String.t()}

    @type t() :: %__MODULE__{
            format: format(),
            gap: number(),
            labels: list(String.t()),

            # Internal
            positions: list(number())
          }

    defstruct format: nil,
              gap: 0,
              labels: [],
              positions: []

    def put(axis, config, default) do
      major_ticks_text =
        %__MODULE__{
          format:
            Utils.key_guard(
              config,
              :axis_tick_labels_format,
              default.axis_tick_labels_format,
              &Validators.validate_axis_tick_labels_format/1
            ),
          gap:
            Utils.key_guard(
              config,
              :axis_tick_gap_labels,
              default.axis_tick_gap_labels,
              &Validators.validate_number/1
            ),
          labels:
            Utils.key_guard(
              config,
              :axis_tick_labels,
              default.axis_tick_labels,
              &Validators.validate_labels/1
            )
        }
        |> set_positions(axis.major_ticks.positions)

      Kernel.put_in(axis.major_ticks_text, major_ticks_text)
    end

    # Private

    defp set_positions(major_ticks_text, positions) do
      Map.put(major_ticks_text, :positions, positions)
    end
  end

  def put(config, default) do
    %__MODULE__{
      scale:
        Utils.key_guard(
          config,
          :axis_scale,
          default.scale,
          &Validators.validate_axis_scale/1
        ),
      thickness:
        Utils.key_guard(
          config,
          :axis_thickness,
          default.thickness,
          &Validators.validate_positive_number/1
        )
    }
    |> MajorTicks.put(config, default)
    |> MinorTicks.put(config, default)
    |> MajorTicksText.put(config, default)
  end

  # Private
end
