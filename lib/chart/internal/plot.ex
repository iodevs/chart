defmodule Chart.Internal.Plot do
  @moduledoc false

  alias Chart.Internal.{Axis, TextPosition, Utils, Validators}

  @type t() :: %__MODULE__{
          # box: :on | :off,
          grid: nil | Grid.t(),
          position: nil | {number(), number()},
          size: nil | {number(), number()},
          x_axis: nil | Axis.t(),
          x_axis_label: nil | TextPosition.t(),
          y_axis: nil | Axis.t(),
          y_axis_label: nil | TextPosition.t()
          # viewbox: nil | {pos_integer(), pos_integer()}

          # Internal
        }

  defstruct grid: nil,
            # box: :off,
            position: nil,
            size: nil,
            x_axis: nil,
            x_axis_label: nil,
            y_axis: nil,
            y_axis_label: nil

  defmodule Grid do
    @moduledoc false

    defguard grid_placement(grid) when grid in [:bottom, :top]
    defguard grid_turn(grid) when grid in [:on, :off]

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
        major_turn:
          Utils.key_guard(config, :grid_major_turn, :on, &Validators.validate_grid_turn/1),
        minor_gap:
          Utils.key_guard(config, :grid_minor_gap, 0.5, &Validators.validate_positive_number/1),
        minor_placement:
          Utils.key_guard(
            config,
            :grid_minor_placement,
            :bottom,
            &Validators.validate_grid_placement/1
          ),
        minor_turn:
          Utils.key_guard(config, :grid_minor_turn, :off, &Validators.validate_grid_turn/1)
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
          )
      }
      |> set_plot_position(config, figure.viewbox)
      |> Grid.put(config)
      |> set_x_axis(config)
      |> set_y_axis(config)

    Kernel.put_in(figure.plot, plot)
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
  end

  defp set_y_axis(plot, config) do
  end
end
