defmodule Chart.Internal.Figure do
  @moduledoc false

  alias Chart.Internal.{Plot, Utils, Validators}

  @type t() :: %__MODULE__{
          # legend: nil | Legend.t(),
          plot: nil | Plot.t(),
          # subtitle: nil | Strings.t(),
          # title: nil | String.t(),
          # title_position: nil | TextPosition.position(),
          viewbox: nil | {pos_integer(), pos_integer()}

          # Internal
          # title_text: nil | TextPosition.t()
        }

  defstruct plot: nil,
            # subtitle: nil,
            # title: nil,
            # title_position: nil,
            viewbox: nil

  # Internal
  # title_text: nil

  @spec put(list()) :: t()
  def put(config \\ []) do
    %__MODULE__{
      viewbox: Utils.key_guard(config, :fig_viewbox, {800, 600}, &Validators.validate_viewbox/1)
    }
    # |> Legend.put(config)
    # |> TextPosition.put(config)
    |> Plot.put(config)
  end
end
