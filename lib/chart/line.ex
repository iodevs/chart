defmodule Chart.Line do
  @moduledoc """
  A line chart definition structure
  """

  alias Chart.Line.{Settings, Svg}

  defstruct settings: nil,
            data: nil

  def new() do
    %__MODULE__{
      settings: nil,
      data: nil
    }
  end

  def put(%__MODULE__{} = line, data) do
    %{line | data: data}
  end

  def render(%__MODULE__{} = line) do
    line |> Svg.generate()
  end

  def setup() do
    new()
    |> put_settings(Settings.new())
  end

  def put_settings(%__MODULE__{} = chart, settings) when is_map(settings) do
    Map.put(chart, :settings, settings)
  end
end
