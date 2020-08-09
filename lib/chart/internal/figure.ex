defmodule Chart.Internal.Figure do
  @moduledoc false

  alias Chart.Internal.{Axis, Plot, Text, Utils, Validators}
  alias Chart.Internal.Axis.{Label, MajorTicks, MinorTicks, MajorTicksText}

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
    plot =
      config
      |> Plot.new(plot_validators())
      # |> set_x_axis(config)
      |> set_axis("x", config)
      |> set_axis("y", config)
      # |> Kernel.put_in(
      #   [:major_ticks],
      #   MajorTicks.set_positions({0, elem(plot.size, 0)}, axis.scale)
      # )
      # |> set_y_axis(config)
      |> Map.put(:grid, Plot.Grid.new(config))

    %__MODULE__{
      viewbox: Utils.key_guard(config, :fig_viewbox, @fig_viewbox, &Validators.validate_viewbox/1)
    }
    # |> Legend.put(config)
    |> Map.put(:title, Text.new(config, title_validators()))
    |> Map.put(:plot, plot)
  end

  # Private

  defp plot_validators() do
    %{
      position:
        {:plot_position, &Validators.validate_plot_size(&1, {@fig_viewbox, %Plot{}.size})},
      rect_bg_padding: {:plot_bg_padding, &Validators.validate_rect_bg_padding/1},
      size: {:plot_size, &Validators.validate_plot_size(&1, @fig_viewbox)}
    }
  end

  defp title_validators() do
    %{
      gap: {:title_text_gap, &Validators.validate_number/1},
      position: {:title_text_position, &Validators.validate_position/1},
      rect_bg: {:title_text_rect_bg, &Validators.validate_turn/1},
      show: {:title_show, &Validators.validate_turn/1},
      text: {:title_text, &Validators.validate_string/1}
    }
  end

  def set_axis(plot, axis_name, config) do
    axis_label_validators = Utils.update_validators("#{axis_name}_axis_label", Label.validators())
    axis_validators = Utils.update_validators("#{axis_name}_axis", Axis.validators())

    major_ticks_validators =
      Utils.update_validators("#{axis_name}_axis_major_ticks", MajorTicks.validators())

    minor_ticks_validators =
      Utils.update_validators("#{axis_name}_axis_minor_ticks", MinorTicks.validators())

    major_ticks_text_validators =
      Utils.update_validators("#{axis_name}_axis_ticks_text", MajorTicksText.validators())

    axis = Axis.new(config, axis_validators)

    major_ticks =
      config
      |> MajorTicks.new(major_ticks_validators)

    # |> MajorTicks.set_positions({0, elem(plot.size, 0)}, axis.scale)

    minor_ticks =
      config
      |> MinorTicks.new(minor_ticks_validators)

    # |> MinorTicks.set_positions(range_for_positions, axis.scale)

    major_ticks_text =
      config
      |> MajorTicksText.new(major_ticks_text_validators)
      |> MajorTicksText.set(:positions, major_ticks.positions)

    axis_label =
      config
      |> Label.new(axis_label_validators)
      |> Label.set_position(plot.position, plot.size)

    axis_new =
      axis
      |> Axis.set(:major_ticks, major_ticks)
      |> Axis.set(:minor_ticks, minor_ticks)
      |> Axis.set(:major_ticks_text, major_ticks_text)
      |> Axis.set(:label, axis_label)

    # |> Axis.set_x_axis_line(plot.position, plot.size)

    Map.put(plot, String.to_atom("#{axis_name}_axis"), axis_new)
  end

  defp set_x_axis(plot, config) do
    axis_label_validators = Utils.update_validators("x_axis_label", Label.validators())
    x_axis_validators = Utils.update_validators("x_axis", Axis.validators())

    x_major_ticks_validators =
      Utils.update_validators("x_axis_major_ticks", MajorTicks.validators())

    x_minor_ticks_validators =
      Utils.update_validators("x_axis_minor_ticks", MinorTicks.validators())

    major_ticks_text_validators =
      Utils.update_validators("x_axis_ticks_text", MajorTicksText.validators())

    axis = Axis.new(config, x_axis_validators)
    range_for_positions = {0, elem(plot.size, 0)}

    major_ticks =
      config
      |> MajorTicks.new(x_major_ticks_validators)
      |> MajorTicks.set_positions(range_for_positions, axis.scale)

    minor_ticks =
      config
      |> MinorTicks.new(x_minor_ticks_validators)
      |> MinorTicks.set_positions(range_for_positions, axis.scale)

    major_ticks_text =
      config
      |> MajorTicksText.new(major_ticks_text_validators)
      |> MajorTicksText.set(:positions, major_ticks.positions)

    axis_label =
      config
      |> Label.new(axis_label_validators)
      |> Label.set_position(plot.position, plot.size)

    axis_new =
      axis
      |> Axis.set(:major_ticks, major_ticks)
      |> Axis.set(:minor_ticks, minor_ticks)
      |> Axis.set(:major_ticks_text, major_ticks_text)
      |> Axis.set(:label, axis_label)
      |> Axis.set_x_axis_line(plot.position, plot.size)

    Map.put(plot, :x_axis, axis_new)
  end

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
end
