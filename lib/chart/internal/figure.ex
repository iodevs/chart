defmodule Chart.Internal.Figure do
  @moduledoc false

  alias Chart.Internal.{Plot, Text, Utils, Validators}

  @fig_viewbox {800, 600}

  @type t() :: %__MODULE__{
          # legend: Maybe.t(Legend.t()),
          plot: Maybe.t(Plot.t()),
          title: Maybe.t(Text.t()),
          viewbox: Maybe.t({pos_integer(), pos_integer()})
        }

  defstruct plot: nil,
            title: nil,
            viewbox: nil

  @spec put(list()) :: t()
  def put(config \\ []) do
    title = config |> text_cfg() |> Text.new(text_validators())
    plot = config |> plot_cfg() |> Plot.new(plot_validators())
    x_axis = config |> x_axis_cfg() |> Axis.new(x_axis_validators())
    y_axis = config |> y_axis_cfg() |> Axis.new(y_axis_validators())

    %__MODULE__{
      viewbox: Utils.key_guard(config, :fig_viewbox, @fig_viewbox, &Validators.validate_viewbox/1)
    }
    # |> Legend.put(config)
    |> Map.put(:title, title)
    |> Map.put(:plot, plot)
    |> Kernel.put_in([:plot, :x_axis], x_axis)
    |> Kernel.put_in([:plot, :y_axis], y_axis)

    # |> Kernel.put_in([:plot, :grid], grid)
  end

  # Private

  defp plot_cfg(config) do
    [
      plot_bg_padding: config[:plot_bg_padding],
      plot_position: config[:plot_position],
      plot_size: config[:plot_size]
    ]
  end

  defp plot_validators() do
    %{
      position:
        {:plot_position, &Validators.validate_plot_size(&1, {@fig_viewbox, %Plot{}.size})},
      rect_bg_padding: {:plot_bg_padding, &Validators.validate_rect_bg_padding/1},
      size: {:plot_size, &Validators.validate_plot_size(&1, @fig_viewbox)}
    }
  end

  defp x_axis_cfg(config) do
    [
      x_scale: config[:x_scale],
      x_thickness: config[:x_thickness]
    ]
  end

  defp x_axis_validators() do
    [
      scale: {:x_scale, &Validators.validate_axis_scale/1},
      thickness: {:x_thickness, &Validators.validate_positive_number/1}
    ]
  end

  defp y_axis_cfg(config) do
    [
      y_scale: config[:y_scale],
      y_thickness: config[:y_thickness]
    ]
  end

  defp y_axis_validators() do
    [
      scale: {:y_scale, &Validators.validate_axis_scale/1},
      thickness: {:y_thickness, &Validators.validate_positive_number/1}
    ]
  end

  # defp set_x_axis(plot, config) do
  #   axis_new =
  #     Axis.new()
  #     |> Axis.put(:scale, :x_scale, config)
  #     |> Axis.put(:thickness, :x_thickness, config)

  #   major_ticks =
  #     MajorTicks.new()
  #     |> MajorTicks.set(:range, {0, elem(plot.size, 0)})
  #     |> MajorTicks.put(:count, :x_major_ticks_count, config)
  #     |> MajorTicks.put(:gap, :x_major_ticks_gap, config)
  #     |> MajorTicks.put(:length, :x_major_ticks_length, config)
  #     |> MajorTicks.put(:range, :x_major_ticks_range, config)
  #     |> MajorTicks.set(:positions, axis_new.scale)

  #   minor_ticks =
  #     MinorTicks.new()
  #     |> MinorTicks.set(:range, {0, elem(plot.size, 0)})
  #     |> MinorTicks.put(:count, :x_minor_ticks_count, config)
  #     |> MinorTicks.put(:gap, :x_minor_ticks_gap, config)
  #     |> MinorTicks.put(:length, :x_minor_ticks_length, config)
  #     |> MinorTicks.put(:range, :x_minor_ticks_range, config)
  #     |> MinorTicks.set(:positions, axis_new.scale)

  #   major_ticks_text =
  #     MajorTicksText.new()
  #     |> MajorTicksText.put(:format, :x_axis_tick_labels_format, config)
  #     |> MajorTicksText.put(:gap, :x_axis_tick_gap_labels, config)
  #     |> MajorTicksText.put(:labels, :x_axis_tick_labels, config)
  #     |> MajorTicksText.set(:positions, major_ticks.positions)

  #   label =
  #     Text.new()
  #     |> Text.set(:text, "Axis x")
  #     |> Text.set(:position, {400, 560})
  #     |> Text.put(:gap, :x_axis_text_gap, config)
  #     |> Text.put(:placement, :x_axis_text_placement, config)
  #     |> Text.put(:rect_bg, :x_axis_text_rect_bg, config)
  #     |> Text.put(:show, :x_axis_text_show, config)
  #     |> Text.put(:text, :x_axis_text, config)

  #   axis =
  #     axis_new
  #     |> Map.put(:major_ticks, major_ticks)
  #     |> Map.put(:minor_ticks, minor_ticks)
  #     |> Map.put(:major_ticks_text, major_ticks_text)
  #     |> Map.put(:label, label)
  #     |> set_x_axis_line(plot.position, plot.size)

  #   Map.put(plot, :x_axis, axis)
  # end

  # defp set_y_axis(plot, config) do
  #   axis_new =
  #     Axis.new()
  #     |> Axis.put(:scale, :y_scale, config)
  #     |> Axis.put(:thickness, :y_thickness, config)

  #   major_ticks =
  #     MajorTicks.new()
  #     |> MajorTicks.set(:count, 5)
  #     |> MajorTicks.set(:range, {0, elem(plot.size, 1)})
  #     |> MajorTicks.put(:count, :y_major_ticks_count, config)
  #     |> MajorTicks.put(:gap, :y_major_ticks_gap, config)
  #     |> MajorTicks.put(:length, :y_major_ticks_length, config)
  #     |> MajorTicks.put(:range, :y_major_ticks_range, config)
  #     |> MajorTicks.set(:positions, axis_new.scale)

  #   minor_ticks =
  #     MinorTicks.new()
  #     |> MinorTicks.set(:range, {0, elem(plot.size, 1)})
  #     |> MinorTicks.put(:count, :y_minor_ticks_count, config)
  #     |> MinorTicks.put(:gap, :y_minor_ticks_gap, config)
  #     |> MinorTicks.put(:length, :y_minor_ticks_length, config)
  #     |> MinorTicks.put(:range, :y_minor_ticks_range, config)
  #     |> MinorTicks.set(:positions, axis_new.scale)

  #   major_ticks_text =
  #     MajorTicksText.new()
  #     |> MajorTicksText.put(:format, :y_axis_tick_labels_format, config)
  #     |> MajorTicksText.put(:gap, :y_axis_tick_gap_labels, config)
  #     |> MajorTicksText.put(:labels, :y_axis_tick_labels, config)
  #     |> MajorTicksText.set(:positions, major_ticks.positions)

  #   label =
  #     Text.new()
  #     |> Text.set(:text, "Axis y")
  #     |> Text.set(:position, {40, 110})
  #     |> Text.set(:placement, :top)
  #     |> Text.put(:gap, :y_axis_text_gap, config)
  #     |> Text.put(:placement, :y_axis_text_placement, config)
  #     |> Text.put(:rect_bg, :y_axis_text_rect_bg, config)
  #     |> Text.put(:show, :y_axis_text_show, config)
  #     |> Text.put(:text, :y_axis_text, config)

  #   axis =
  #     axis_new
  #     |> Map.put(:major_ticks, major_ticks)
  #     |> Map.put(:minor_ticks, minor_ticks)
  #     |> Map.put(:major_ticks_text, major_ticks_text)
  #     |> Map.put(:label, label)
  #     |> set_y_axis_line(plot.position, plot.size, axis_new.thickness)

  #   Map.put(plot, :y_axis, axis)
  # end

  # defp set_x_axis_line(axis, {pos_x, pos_y}, {width, height}) do
  #   line = {pos_x, pos_y + height, pos_x + width, pos_y + height, axis.thickness}

  #   Map.put(axis, :line, line)
  # end

  # defp set_y_axis_line(axis, {pos_x, pos_y}, {_width, height}, thickness) do
  #   line = {pos_x, pos_y, pos_x, pos_y + height + thickness / 2, axis.thickness}

  #   Map.put(axis, :line, line)
  # end

  defp text_cfg(config) do
    [
      title_text_gap: config[:title_text_gap],
      title_text_placement: config[:placement],
      title_text_rect_bg: config[:rect_bg],
      title_show: config[:show],
      title_text_gap: config[:title_text_gap],
      title_text: config[:title_text]
    ]
  end

  defp text_validators() do
    %{
      gap: {:title_text_gap, &Validators.validate_number/1},
      placement: {:title_text_placement, &Validators.validate_text_placement/1},
      rect_bg: {:title_text_rect_bg, &Validators.validate_turn/1},
      show: {:title_show, &Validators.validate_turn/1},
      text: {:title_text, &Validators.validate_string/1}
    }
  end
end
