defmodule Chart.Internal.Plot do
  @moduledoc false

  alias Chart.Internal.{Axis, TextPosition, Utils, Validators}

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
          grid: nil | Grid.t(),
          position: nil | {number(), number()},
          # origin_cs: nil | origin_cs(),
          rect_bg_padding: nil | {number(), number(), number(), number()},
          size: nil | {number(), number()},
          x_axis: nil | Axis.t(),
          y_axis: nil | Axis.t()
          # viewbox: nil | {pos_integer(), pos_integer()}

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

    defguard grid_placement(grid) when grid in [:bottom, :top]

    @type turn() :: :on | :off
    @type placement() :: :bottom | :top

    @type t() :: %__MODULE__{
            major_gap: nil | number(),
            major_placement: nil | placement(),
            major_turn: nil | turn(),
            minor_gap: nil | number(),
            minor_placement: nil | placement(),
            minor_turn: nil | turn()
          }

    defstruct major_gap: nil,
              major_placement: nil,
              major_turn: nil,
              minor_gap: nil,
              minor_placement: nil,
              minor_turn: nil

    def put(plot, config) do
      grid = %__MODULE__{
        major_gap:
          Utils.key_guard(config, :grid_major_gap, 0.5, &Validators.validate_positive_number/1),
        major_placement:
          Utils.key_guard(
            config,
            :grid_major_placement,
            :bottom,
            &Validators.validate_grid_placement/1
          ),
        major_turn: Utils.key_guard(config, :grid_major_turn, :on, &Validators.validate_turn/1),
        minor_gap:
          Utils.key_guard(config, :grid_minor_gap, 0.5, &Validators.validate_positive_number/1),
        minor_placement:
          Utils.key_guard(
            config,
            :grid_minor_placement,
            :bottom,
            &Validators.validate_grid_placement/1
          ),
        minor_turn: Utils.key_guard(config, :grid_minor_turn, :off, &Validators.validate_turn/1)
      }

      Kernel.put_in(plot.grid, grid)
    end
  end

  def put(figure, config) do
    plot =
      %__MODULE__{
        size:
          Utils.key_guard(
            config,
            :plot_size,
            {600, 400},
            figure.viewbox,
            &Validators.validate_plot_size/2
          ),
        rect_bg_padding:
          Utils.key_guard(
            config,
            :plot_bg_padding,
            {0, 0, 0, 0},
            &Validators.validate_rect_bg_padding/1
          )
      }
      |> set_plot_position(config, figure.viewbox)
      |> set_x_axis(config)
      |> set_y_axis(config)
      |> Grid.put(config)

    Map.put(figure, :plot, plot)
  end

  # Private

  defp set_plot_position(%__MODULE__{size: plot_size} = plot, config, fig_viewbox) do
    position =
      Utils.key_guard(
        config,
        :plot_position,
        {100, 100},
        {fig_viewbox, plot_size},
        &Validators.validate_plot_position/2
      )

    Map.put(plot, :position, position)
  end

  defp set_x_axis(plot, config) do
    default = %{
      axis_tick_gap_labels: 0,
      axis_tick_labels: [],
      axis_tick_labels_format: {:decimals, 0},
      major_ticks_count: 7,
      major_ticks_gap: 0,
      major_ticks_length: 0.5,
      major_ticks_range: {0, elem(plot.size, 0)},
      minor_ticks_count: 20,
      minor_ticks_gap: 0,
      minor_ticks_length: 0.25,
      minor_ticks_range: {0, elem(plot.size, 0)},
      scale: :linear,
      thickness: 2
    }

    axis =
      config
      |> Axis.put(default)
      |> set_x_axis_line(plot.position, plot.size)
      |> set_axis_label(config, default)

    Map.put(plot, :x_axis, axis)
  end

  defp set_y_axis(plot, config) do
    default = %{
      axis_tick_gap_labels: 0,
      axis_tick_labels: [],
      axis_tick_labels_format: {:decimals, 0},
      major_ticks_count: 5,
      major_ticks_gap: 0,
      major_ticks_length: 0.5,
      major_ticks_range: {0, elem(plot.size, 1)},
      minor_ticks_count: 20,
      minor_ticks_gap: 0,
      minor_ticks_length: 0.25,
      minor_ticks_range: {0, elem(plot.size, 1)},
      scale: :linear,
      thickness: 2
    }

    axis =
      config
      |> Axis.put(default)
      |> set_y_axis_line(plot.position, plot.size, plot.x_axis.thickness)
      |> set_axis_label(config, default)

    Map.put(plot, :y_axis, axis)
  end

  # Private

  defp set_x_axis_line(axis, {pos_x, pos_y}, {width, height}) do
    line = {pos_x, pos_y + height, pos_x + width, pos_y + height, axis.thickness}

    Map.put(axis, :line, line)
  end

  defp set_y_axis_line(axis, {pos_x, pos_y}, {_width, height}, thickness) do
    line = {pos_x, pos_y, pos_x, pos_y + height + thickness / 2, axis.thickness}

    Map.put(axis, :line, line)
  end

  defp set_axis_label(axis, config, default) do
    label = ""

    Map.put(axis, :label, label)
  end
end
