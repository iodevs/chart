defmodule Chart.Internal.Plot do
  @moduledoc false

  alias Chart.Internal.{Axis, Text, Utils, Validators}
  alias Chart.Internal.Axis.{MajorTicks, MinorTicks, MajorTicksText}

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

    defguard grid_placement(grid) when grid in [:under, :over]

    @type turn() :: :on | :off
    @type placement() :: :under | :over

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
      grid =
        new()
        |> set(:major_gap, :grid_major_gap, config)
        |> set(:major_placement, :grid_major_placement, config)
        |> set(:major_turn, :grid_major_turn, config)
        |> set(:minor_gap, :grid_minor_gap, config)
        |> set(:minor_placement, :grid_minor_placement, config)
        |> set(:minor_turn, :grid_minor_turn, config)

      Map.put(plot, :grid, grid)
    end

    # Private

    defp new() do
      %__MODULE__{
        major_gap: 0.5,
        major_placement: :under,
        major_turn: :on,
        minor_gap: 0.5,
        minor_placement: :under,
        minor_turn: :off
      }
    end

    defp set(plot, key, config_key, config) do
      Utils.put(plot, key, config_key, config, &validate/0)
    end

    defp validate() do
      %{
        major_gap: &Validators.validate_positive_number/1,
        major_placement: &Validators.validate_grid_placement/1,
        major_turn: &Validators.validate_turn/1,
        minor_gap: &Validators.validate_positive_number/1,
        minor_placement: &Validators.validate_grid_placement/1,
        minor_turn: &Validators.validate_turn/1
      }
    end
  end

  def put(figure, config) do
    plot =
      new()
      |> set_plot_size(config, figure.viewbox)
      |> set_plot_position(config, figure.viewbox)
      |> set(:rect_bg_padding, :plot_bg_padding, config)
      |> set_x_axis(config)
      |> set_y_axis(config)
      |> Grid.put(config)

    Map.put(figure, :plot, plot)
  end

  # Private

  defp new() do
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

  defp validate() do
    %{
      rect_bg_padding: &Validators.validate_rect_bg_padding/1
    }
  end

  defp set(plot, key, config_key, config) do
    Utils.put(plot, key, config_key, config, &validate/0)
  end

  defp set_plot_size(%__MODULE__{size: plot_size} = plot, config, fig_viewbox) do
    size =
      Utils.key_guard(
        config,
        :plot_size,
        plot_size,
        fig_viewbox,
        &Validators.validate_plot_size/2
      )

    Map.put(plot, :size, size)
  end

  defp set_plot_position(
         %__MODULE__{position: plot_position, size: plot_size} = plot,
         config,
         fig_viewbox
       ) do
    position =
      Utils.key_guard(
        config,
        :plot_position,
        plot_position,
        {fig_viewbox, plot_size},
        &Validators.validate_plot_position/2
      )

    Map.put(plot, :position, position)
  end

  defp set_x_axis(plot, config) do
    axis_new =
      Axis.new()
      |> Axis.put(:scale, :x_scale, config)
      |> Axis.put(:thickness, :x_thickness, config)

    major_ticks =
      MajorTicks.new()
      |> MajorTicks.set(:range, {0, elem(plot.size, 0)})
      |> MajorTicks.put(:count, :x_major_ticks_count, config)
      |> MajorTicks.put(:gap, :x_major_ticks_gap, config)
      |> MajorTicks.put(:length, :x_major_ticks_length, config)
      |> MajorTicks.put(:range, :x_major_ticks_range, config)
      |> MajorTicks.set(:positions, axis_new.scale)

    minor_ticks =
      MinorTicks.new()
      |> MinorTicks.set(:range, {0, elem(plot.size, 0)})
      |> MinorTicks.put(:count, :x_minor_ticks_count, config)
      |> MinorTicks.put(:gap, :x_minor_ticks_gap, config)
      |> MinorTicks.put(:length, :x_minor_ticks_length, config)
      |> MinorTicks.put(:range, :x_minor_ticks_range, config)
      |> MinorTicks.set(:positions, axis_new.scale)

    major_ticks_text =
      MajorTicksText.new()
      |> MajorTicksText.put(:format, :x_axis_tick_labels_format, config)
      |> MajorTicksText.put(:gap, :x_axis_tick_gap_labels, config)
      |> MajorTicksText.put(:labels, :x_axis_tick_labels, config)
      |> MajorTicksText.set(:positions, major_ticks.positions)

    label =
      Text.new()
      |> Text.set(:text, "Axis x")
      |> Text.set(:position, {400, 560})
      |> Text.put(:gap, :x_axis_text_gap, config)
      |> Text.put(:placement, :x_axis_text_placement, config)
      |> Text.put(:rect_bg, :x_axis_text_rect_bg, config)
      |> Text.put(:show, :x_axis_text_show, config)
      |> Text.put(:text, :x_axis_text, config)

    axis =
      axis_new
      |> Map.put(:major_ticks, major_ticks)
      |> Map.put(:minor_ticks, minor_ticks)
      |> Map.put(:major_ticks_text, major_ticks_text)
      |> Map.put(:label, label)
      |> set_x_axis_line(plot.position, plot.size)

    Map.put(plot, :x_axis, axis)
  end

  defp set_y_axis(plot, config) do
    axis_new =
      Axis.new()
      |> Axis.put(:scale, :y_scale, config)
      |> Axis.put(:thickness, :y_thickness, config)

    major_ticks =
      MajorTicks.new()
      |> MajorTicks.set(:count, 5)
      |> MajorTicks.set(:range, {0, elem(plot.size, 1)})
      |> MajorTicks.put(:count, :y_major_ticks_count, config)
      |> MajorTicks.put(:gap, :y_major_ticks_gap, config)
      |> MajorTicks.put(:length, :y_major_ticks_length, config)
      |> MajorTicks.put(:range, :y_major_ticks_range, config)
      |> MajorTicks.set(:positions, axis_new.scale)

    minor_ticks =
      MinorTicks.new()
      |> MinorTicks.set(:range, {0, elem(plot.size, 1)})
      |> MinorTicks.put(:count, :y_minor_ticks_count, config)
      |> MinorTicks.put(:gap, :y_minor_ticks_gap, config)
      |> MinorTicks.put(:length, :y_minor_ticks_length, config)
      |> MinorTicks.put(:range, :y_minor_ticks_range, config)
      |> MinorTicks.set(:positions, axis_new.scale)

    major_ticks_text =
      MajorTicksText.new()
      |> MajorTicksText.put(:format, :y_axis_tick_labels_format, config)
      |> MajorTicksText.put(:gap, :y_axis_tick_gap_labels, config)
      |> MajorTicksText.put(:labels, :y_axis_tick_labels, config)
      |> MajorTicksText.set(:positions, major_ticks.positions)

    label =
      Text.new()
      |> Text.set(:text, "Axis y")
      |> Text.set(:position, {40, 110})
      |> Text.set(:placement, :top)
      |> Text.put(:gap, :y_axis_text_gap, config)
      |> Text.put(:placement, :y_axis_text_placement, config)
      |> Text.put(:rect_bg, :y_axis_text_rect_bg, config)
      |> Text.put(:show, :y_axis_text_show, config)
      |> Text.put(:text, :y_axis_text, config)

    axis =
      axis_new
      |> Map.put(:major_ticks, major_ticks)
      |> Map.put(:minor_ticks, minor_ticks)
      |> Map.put(:major_ticks_text, major_ticks_text)
      |> Map.put(:label, label)
      |> set_y_axis_line(plot.position, plot.size, axis_new.thickness)

    Map.put(plot, :y_axis, axis)
  end

  defp set_x_axis_line(axis, {pos_x, pos_y}, {width, height}) do
    line = {pos_x, pos_y + height, pos_x + width, pos_y + height, axis.thickness}

    Map.put(axis, :line, line)
  end

  defp set_y_axis_line(axis, {pos_x, pos_y}, {_width, height}, thickness) do
    line = {pos_x, pos_y, pos_x, pos_y + height + thickness / 2, axis.thickness}

    Map.put(axis, :line, line)
  end
end
