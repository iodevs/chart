defmodule Chart.Gauge.Settings do
  @moduledoc false

  alias Chart.Internal.{Utils, Validators}
  import Chart.Internal.Utils, only: [key_guard: 4]

  @offset_from_bottom 35

  @type t() :: %__MODULE__{
          gauge_bottom_width_lines: nil | number(),
          gauge_value_class: nil | list(tuple()),
          major_ticks: nil | MajorTicks.t(),
          major_ticks_text: nil | MajorTicksText.t(),
          range: nil | {number(), number()},
          thresholds: nil | Thresholds.t(),
          value_text: nil | ValueText.t(),
          viewbox: nil | {pos_integer(), pos_integer()},

          # Internal
          d_gauge_bg_border_bottom_lines: list(tuple()),
          d_gauge_half_circle: tuple(),
          gauge_center: {number(), number()},
          gauge_radius: {number(), number()}
        }

  defstruct gauge_bottom_width_lines: nil,
            gauge_value_class: nil,
            major_ticks: nil,
            major_ticks_text: nil,
            range: nil,
            thresholds: nil,
            value_text: nil,
            viewbox: nil,

            # Internal
            d_gauge_bg_border_bottom_lines: [{}],
            d_gauge_half_circle: {},
            gauge_center: {0, 0},
            gauge_radius: {50, 50}

  defmodule MajorTicks do
    @moduledoc false

    alias Chart.Gauge.Settings
    import Chart.Internal.Utils, only: [key_guard: 4, linspace: 3]

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
      major_ticks =
        %__MODULE__{
          count: key_guard(config, :major_ticks_count, 7, &Validators.validate_ticks_count/1),
          gap: key_guard(config, :major_ticks_gap, 0, &Validators.validate_number/1),
          length:
            key_guard(config, :major_ticks_length, 5, &Validators.validate_positive_number/1)
        }
        |> set_translate(settings)
        |> set_positions()

      Kernel.put_in(settings.major_ticks, major_ticks)
    end

    # Private

    defp set_translate(major_ticks, %Settings{gauge_center: {cx, cy}, gauge_radius: {rx, _ry}}) do
      Map.put(major_ticks, :translate, {cx - rx - major_ticks.gap - 13, cy})
    end

    defp set_positions(major_ticks) do
      angles = linspace(0, 180, major_ticks.count)

      Map.put(major_ticks, :positions, angles)
    end
  end

  defmodule MajorTicksText do
    @moduledoc false

    alias Chart.Internal.{Utils, Validators}
    import Chart.Gauge.Utils, only: [split_major_tick_values: 2]

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
      major_ticks_text =
        %__MODULE__{
          decimals:
            Utils.key_guard(
              config,
              :major_ticks_value_decimals,
              0,
              &Validators.validate_decimals/1
            ),
          gap: Utils.key_guard(config, :major_ticks_text_gap, 0, &Validators.validate_number/1)
        }
        |> set_positions(settings)

      Kernel.put_in(settings.major_ticks_text, major_ticks_text)
    end

    # Private

    defp set_positions(major_ticks_text, settings) do
      count = settings.major_ticks.count

      ticks_text_pos =
        settings.range
        |> Utils.linspace(count)
        |> split_major_tick_values(count)
        |> parse_tick_values(settings, major_ticks_text.gap, major_ticks_text.decimals)

      Map.put(major_ticks_text, :positions, ticks_text_pos)
    end

    defp parse_tick_values([left, center, right], settings, gap, decimals)
         when is_list(left) and is_list(center) and is_list(right) do
      l = left |> compute_positions_with_text_anchor(settings, gap, decimals, "end")
      c = center |> compute_positions_with_text_anchor(settings, gap, decimals, "middle")
      r = right |> compute_positions_with_text_anchor(settings, gap, decimals, "start")

      [l, c, r] |> List.flatten()
    end

    defp parse_tick_values([left, right], settings, gap, decimals)
         when is_list(left) and is_list(right) do
      l = left |> compute_positions_with_text_anchor(settings, gap, decimals, "end")
      r = right |> compute_positions_with_text_anchor(settings, gap, decimals, "start")

      [l, r] |> List.flatten()
    end

    defp compute_positions_with_text_anchor(val_list, settings, gap, decimals, text_anchor) do
      {cx, cy} = settings.gauge_center
      {rx, _ry} = settings.gauge_radius

      radius = rx + @offset_radius_text + gap

      val_list
      |> Enum.map(fn tick_val ->
        phi = Utils.value_to_angle(tick_val, settings.range)
        {x, y} = Utils.polar_to_cartesian(radius, phi)

        {cx + x, cy - y, :erlang.float_to_list(1.0 * tick_val, decimals: decimals), text_anchor}
      end)
    end
  end

  defmodule ValueText do
    @moduledoc false

    alias Chart.Internal.{Utils, Validators}

    @type t() :: %__MODULE__{
            decimals: nil | non_neg_integer(),
            position: nil | {number(), number()}
          }

    defstruct decimals: nil,
              position: nil

    def put(settings, config) do
      value_text =
        %__MODULE__{
          decimals: key_guard(config, :value_text_decimals, 0, &Validators.validate_decimals/1),
          position:
            Utils.key_guard(
              config,
              :value_text_position,
              {0, -10},
              &Validators.validate_position/1
            )
        }
        |> set_position(settings.gauge_center)

      Kernel.put_in(settings.value_text, value_text)
    end

    # Private

    defp set_position(value_text, {cx, cy}) do
      {x, y} = value_text.position

      Map.put(value_text, :position, {cx + x, cy + y})
    end
  end

  defmodule Thresholds do
    @moduledoc false

    alias Chart.Internal.{Utils, Validators}

    @type t() :: %__MODULE__{
            positions_with_class_name: nil | list(tuple()),
            width: nil | non_neg_integer(),

            # Internal
            d_thresholds_with_class: list(tuple())
          }

    defstruct positions_with_class_name: nil,
              width: nil,
              d_thresholds_with_class: [{}]

    def put(settings, config) do
      thresholds =
        %__MODULE__{
          positions_with_class_name:
            Utils.key_guard(config, :thresholds, [], &Validators.validate_list_of_tuples/1),
          width:
            Utils.key_guard(config, :treshold_width, 1, &Validators.validate_positive_number/1)
        }
        |> set_thresholds(settings)

      Kernel.put_in(settings.thresholds, thresholds)
    end

    # Private

    defp set_thresholds(thresholds, settings) do
      {cx, cy} = settings.gauge_center
      {rx, _ry} = settings.gauge_radius
      width = thresholds.width

      d_thresholds_with_class =
        thresholds.positions_with_class_name
        |> Enum.map(fn {val, class} ->
          phi = Utils.value_to_angle(val, settings.range)
          angle = 180.0 - Utils.radian_to_degree(phi) + width / 2.0

          {cx - rx, cy, width, angle, class}
        end)

      Map.put(thresholds, :d_thresholds_with_class, d_thresholds_with_class)
    end
  end

  @spec set(list()) :: t()
  def set(config) do
    %__MODULE__{
      gauge_bottom_width_lines:
        key_guard(config, :gauge_bottom_width_lines, 1.25, &Validators.validate_number/1),
      gauge_value_class:
        key_guard(config, :gauge_value_class, [], &Validators.validate_list_of_tuples/1),
      range: key_guard(config, :range, {0, 300}, &Validators.validate_range/1),
      viewbox: key_guard(config, :viewbox, {160, 80}, &Validators.validate_viewbox/1)
    }
    |> set_gauge_center_circle()
    |> set_gauge_half_circle()
    |> set_gauge_bg_border_bottom_lines()
    |> MajorTicks.put(config)
    |> MajorTicksText.put(config)
    |> ValueText.put(config)
    |> Thresholds.put(config)
  end

  # Private

  # Setters for map keys

  defp set_gauge_center_circle(%__MODULE__{viewbox: {w, h}} = settings) do
    Kernel.put_in(settings.gauge_center, {w / 2, h / 2 + @offset_from_bottom})
  end

  defp set_gauge_half_circle(
         %__MODULE__{gauge_center: {cx, cy}, gauge_radius: {rx, ry}} = settings
       ) do
    Kernel.put_in(settings.d_gauge_half_circle, {cx, cy, rx, ry})
  end

  defp set_gauge_bg_border_bottom_lines(
         %__MODULE__{gauge_center: {cx, cy}, gauge_radius: {rx, _ry}} = settings
       ) do
    width = settings.gauge_bottom_width_lines

    Kernel.put_in(
      settings.d_gauge_bg_border_bottom_lines,
      [
        {cx - rx, cy - 0.5, width},
        {cx + rx, cy - 0.5, width}
      ]
    )
  end
end
