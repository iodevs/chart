defmodule Chart.Internal.Grid do
  @moduledoc false

  alias ExMaybe, as: Maybe

  defguard grid_placement(grid) when grid in [:under, :over]

  @type turn() :: :on | :off
  @type placement() :: :under | :over

  def new() do
    %{
      major_gap: 0.5,
      major_placement: :under,
      major_turn: :on,
      minor_gap: 0.5,
      minor_placement: :under,
      minor_turn: :off
    }
  end

  def add(settings) when is_map(settings) do
    Map.put(settings, :grid, new())
  end

  def put_major_gap(settings, number)
      when is_map(settings) and is_number(number) and number > 0 do
    put_in(settings, [:grid, :major_gap], number)
  end

  def put_major_placement(settings, placement)
      when is_map(settings) and grid_placement(placement) do
    put_in(settings, [:grid, :major_placement], placement)
  end

  def put_minor_placement(settings, placement)
      when is_map(settings) and grid_placement(placement) do
    put_in(settings, [:grid, :minor_placement], placement)
  end
end
