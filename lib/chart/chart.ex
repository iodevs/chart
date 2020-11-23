defmodule Chart.Chart do
  @moduledoc """
  A chart definition structure
  """

  defstruct callbacks: nil,
            settings: nil,
            storage: nil

  def new(manager) do
    %__MODULE__{
      callbacks: [],
      settings: nil,
      storage: manager.new()
    }
  end

  def append_data(%__MODULE__{storage: %module{}} = chart, data) do
    module.append(chart, data)
  end

  def put_data(%__MODULE__{storage: %module{}} = chart, data) do
    module.put(chart, data)
  end

  def reset_data(%__MODULE__{storage: %module{}} = chart) do
    module.reset(chart)
  end

  def put_settings(%__MODULE__{} = chart, settings) when is_map(settings) do
    Map.put(chart, :settings, settings)
  end

  def put_data_manager(%__MODULE__{} = chart, manager) do
    Map.put(chart, :storage, manager.new())
  end

  def register(%__MODULE__{} = chart, callbacks) when is_list(callbacks) do
    Map.put(chart, :callbacks, callbacks)
  end

  def apply_callbacks(%__MODULE__{callbacks: callbacks} = chart) do
    Enum.reduce(callbacks, chart, fn cb, acc -> cb.(acc) end)
  end
end
