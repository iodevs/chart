defmodule Chart.Chart do
  @moduledoc """
  A chart definition structure
  """

  defstruct settings: nil,
            data: nil

  def new() do
    %__MODULE__{
      settings: nil,
      data: nil
    }
  end

  def put_settings(%__MODULE__{} = chart, settings) when is_map(settings) do
    Map.put(chart, :settings, settings)
  end

  def put_data(%__MODULE__{} = chart, data) do
    Map.put(chart, :data, data)
  end
end
