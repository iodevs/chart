defmodule Chart.Internal.GridLine do
  @moduledoc false

  import Chart.Internal.Guards, only: [is_positive_number: 1]

  @self_key :grid

  defguard grid_placement(grid) when grid in [:under, :over]
  defguard grid_type(type) when type in [:major, :minor]

  def new() do
    %{
      gap: 0.25,
      placement: :under
    }
  end

  def add(settings) when is_map(settings) do
    Map.put(settings, @self_key, %{})
  end

  # Setters

  def set_grid(settings, key) when is_map(settings) and grid_type(key) do
    put_in(settings, [@self_key, key], new())
  end

  @doc """
  gap :: 0 < number
  """
  def set_gap(settings, key, number)
      when is_map(settings) and is_atom(key) and is_positive_number(number) do
    put_in(settings, [@self_key, key, :gap], number)
  end

  @doc """
  placement :: :under | :over
  """
  def set_placement(settings, key, placement)
      when is_map(settings) and is_atom(key) and grid_placement(placement) do
    put_in(settings, [@self_key, key, :placement], placement)
  end
end
