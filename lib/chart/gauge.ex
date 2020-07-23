defmodule Chart.Gauge do
  @moduledoc """
  Gauge graph
  """

  alias Chart.Gauge.{Settings, Svg}

  @type data() :: nil | number() | list() | map()
  @type t() :: %__MODULE__{
          settings: Settings.t(),
          data: data()
        }

  defstruct settings: %Settings{},
            data: nil

  @doc """
  Setup a visual view of gauge graph.
  """
  @spec setup(list()) :: t()
  def setup(config_keywords) do
    %__MODULE__{settings: Settings.set(config_keywords)}
  end

  def put(%__MODULE__{} = gauge, data) do
    %{gauge | data: data}
  end

  def render(%__MODULE__{} = gauge) do
    gauge |> Svg.generate()
  end
end
