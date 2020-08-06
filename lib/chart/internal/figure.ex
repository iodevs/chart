defmodule Chart.Internal.Figure do
  @moduledoc false

  alias Chart.Internal.{Plot, Text, Utils, Validators}

  @type t() :: %__MODULE__{
          # legend: nil | Legend.t(),
          plot: nil | Plot.t(),
          title: nil | Text.t(),
          viewbox: nil | {pos_integer(), pos_integer()}
        }

  defstruct plot: nil,
            title: nil,
            viewbox: nil

  @spec put(list()) :: t()
  def put(config \\ []) do
    title =
      Text.new()
      |> Text.set(:text, "Graph")
      |> Text.put(:gap, :title_text_gap, config)
      |> Text.put(:placement, :title_text_placement, config)
      |> Text.put(:rect_bg, :title_text_rect_bg, config)
      |> Text.put(:show, :title_show, config)
      |> Text.put(:text, :title_text, config)

    %__MODULE__{
      viewbox: Utils.key_guard(config, :fig_viewbox, {800, 600}, &Validators.validate_viewbox/1)
    }
    # |> Legend.put(config)
    |> Map.put(:title, title)
    |> Plot.put(config)
  end
end
