defmodule Chart.Internal.Axis do
  @moduledoc false

  alias ExMaybe, as: Maybe

  defguard scale(s) when s in [:linear, :log]

  @type scale() :: :linear | :log

  def new() do
    %{
      scale: :linear,
      thickness: 2,
      line: nil
    }
  end

  def add(settings, key) do
    Map.put(settings, key, new())
  end

  def put_scale(settings, key, scale) when is_map(settings) and is_atom(key) and scale(scale) do
    put_in(settings, [key, :scale], scale)
  end

  def put_thickness(settings, key, thickness)
      when is_map(settings) and is_atom(key) and is_number(thickness) and thickness > 0 do
    put_in(settings, [key, :thickness], thickness)
  end
end
