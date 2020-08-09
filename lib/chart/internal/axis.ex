defmodule Chart.Internal.Axis do
  @moduledoc false

  alias Chart.Internal.{MajorTicks, MinorTicks, MajorTicksText, Label, Utils, Validators}
  alias ExMaybe, as: Maybe

  defguard scale(s) when s in [:linear, :log]

  @type scale() :: :linear | :log

  @type t() :: %__MODULE__{
          label: Maybe.t(Label.t()),
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

  def new(kw, validators \\ validators()) when is_list(kw) and is_map(validators) do
    Utils.merge(new(), kw, validators)
  end

  def put(module, key, value, validators) do
    Utils.put(module, key, value, validators)
  end

  def set(module, key, value) do
    Map.put(module, key, value)
  end

  def set_x_axis_line(axis, {pos_x, pos_y}, {width, height}) do
    line = {pos_x, pos_y + height, pos_x + width, pos_y + height, axis.thickness}

    Map.put(axis, :line, line)
  end

  def set_y_axis_line(axis, {pos_x, pos_y}, {_width, height}, thickness) do
    line = {pos_x, pos_y, pos_x, pos_y + height + thickness / 2, axis.thickness}

    Map.put(axis, :line, line)
  end

  def validators() do
    %{
      scale: {:scale, &Validators.validate_axis_scale/1},
      thickness: {:thickness, &Validators.validate_positive_number/1}
    }
  end

  defmodule Label do
    @moduledoc false

    alias Chart.Internal.{Utils, Validators}
    alias ExMaybe, as: Maybe

    @gap_from_bottom 60
    @gap_from_left 20

    defguard label_placement(pl) when pl in [:left, :center, :right, :top, :middle, :bottom]

    @type placement() :: :left | :center | :right | :top | :middle | :bottom
    @type point() :: {number(), number()}
    @type turn() :: :on | :off

    @type t() :: %__MODULE__{
            adjust_placement: Maybe.t(point()),
            placement: Maybe.t(placement()),
            rect_bg: Maybe.t(turn()),
            show: Maybe.t(turn()),
            text: Maybe.t(String.t()),

            # Internal
            position: Maybe.t(point())
          }

    defstruct adjust_placement: nil,
              placement: nil,
              rect_bg: nil,
              show: nil,
              text: nil,

              # Internal
              position: nil

    def new() do
      %__MODULE__{
        adjust_placement: {0, 0},
        placement: :center,
        rect_bg: :off,
        show: :on,
        text: "",
        position: {0, 0}
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

    def set_position(text, plot_position, plot_size) do
      position =
        compute_label_position(text.placement, text.adjust_placement, plot_position, plot_size)

      Map.put(text, :position, position)
    end

    def validators() do
      %{
        adjust_placement: {:adjust_placement, &Validators.validate_number/1},
        placement: {:placement, fn pl when label_placement(pl) -> pl end},
        rect_bg: {:rect_bg, &Validators.validate_turn/1},
        show: {:show, &Validators.validate_turn/1},
        text: {:text, &Validators.validate_string/1}
      }
    end

    # Private

    # compute_label_position(placement, adjust_placement, plot_position, plot_size)
    defp compute_label_position(:left, {ad_pl_x, ad_pl_y}, {pos_x, pos_y}, {_width, height}) do
      {pos_x + ad_pl_x, pos_y + height + @gap_from_bottom + ad_pl_y}
    end

    defp compute_label_position(:center, {ad_pl_x, ad_pl_y}, {pos_x, pos_y}, {width, height}) do
      {pos_x + width / 2 + ad_pl_x, pos_y + height + @gap_from_bottom + ad_pl_y}
    end

    defp compute_label_position(:right, {ad_pl_x, ad_pl_y}, {pos_x, pos_y}, {width, height}) do
      {pos_x + width + ad_pl_x, pos_y + height + @gap_from_bottom + ad_pl_y}
    end

    defp compute_label_position(:top, {ad_pl_x, ad_pl_y}, {pos_x, pos_y}, {_width, _height}) do
      {pos_x - @gap_from_left + ad_pl_x, pos_y + ad_pl_y}
    end

    defp compute_label_position(:middle, {ad_pl_x, ad_pl_y}, {pos_x, pos_y}, {_width, height}) do
      {pos_x - @gap_from_left + ad_pl_x, pos_y + height / 2 + ad_pl_y}
    end

    defp compute_label_position(:bottom, {ad_pl_x, ad_pl_y}, {pos_x, pos_y}, {_width, height}) do
      {pos_x - @gap_from_left + ad_pl_x, pos_y + height + ad_pl_y}
    end
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

    def new(kw, validators \\ validators()) when is_list(kw) and is_map(validators) do
      Utils.merge(new(), kw, validators)
    end

    def put(module, key, value, validators) do
      Utils.put(module, key, value, validators)
    end

    def set_positions(major_ticks, range, scale) do
      positions = compute_positions(range, major_ticks.count, scale)

      Map.put(major_ticks, :positions, positions)
    end

    def validators() do
      %{
        count: {:count, &Validators.validate_ticks_count/1},
        gap: {:gap, &Validators.validate_number/1},
        length: {:length, &Validators.validate_positive_number/1},
        range: {:range, &Validators.validate_range/1}
      }
    end

    # Private

    defp compute_positions(range, count, :linear) do
      Utils.linspace(range, count)
    end

    defp compute_positions(range, count, :log) do
      Utils.logspace(range, count)
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

    def new(kw, validators \\ validators()) when is_list(kw) and is_map(validators) do
      Utils.merge(new(), kw, validators)
    end

    def put(module, key, value, validators) do
      Utils.put(module, key, value, validators)
    end

    def set_positions(major_ticks, range, scale) do
      positions = compute_positions(range, major_ticks.count, scale)

      Map.put(major_ticks, :positions, positions)
    end

    def validators() do
      %{
        count: {:count, &Validators.validate_ticks_count/1},
        gap: {:gap, &Validators.validate_number/1},
        length: {:length, &Validators.validate_positive_number/1},
        range: {:range, &Validators.validate_range/1}
      }
    end

    # Private

    defp compute_positions(range, count, :linear) do
      Utils.linspace(range, count)
    end

    defp compute_positions(range, count, :log) do
      Utils.logspace(range, count)
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

    def new(kw, validators \\ validators()) when is_list(kw) and is_map(validators) do
      Utils.merge(new(), kw, validators)
    end

    def put(module, key, value, validators) do
      Utils.put(module, key, value, validators)
    end

    def set(module, key, value) do
      Map.put(module, key, value)
    end

    def validators() do
      %{
        format: {:format, &Validators.validate_axis_tick_labels_format/1},
        gap: {:gap, &Validators.validate_number/1},
        labels: {:labels, &Validators.validate_labels/1}
      }
    end
  end
end
