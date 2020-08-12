defmodule Chart.Internal.GridLine do
  @moduledoc false

  import Chart.Internal.Guards, only: [is_positive_number: 1, is_turn: 1]

  @self_key :grid

  defguard grid_placement(grid) when grid in [:under, :over]

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
    Map.put(settings, @self_key, new())
  end

  # Setters

  @doc """
  gap :: 0 < number
  """
  def set_major_gap(settings, number)
      when is_map(settings) and is_positive_number(number) do
    put_in(settings, [@self_key, :major_gap], number)
  end

  @doc """
  placement :: :under | :over
  """
  def set_major_placement(settings, placement)
      when is_map(settings) and grid_placement(placement) do
    put_in(settings, [@self_key, :major_placement], placement)
  end

  @doc """
  turn :: :on | :off
  """
  def set_major_turn(settings, turn)
      when is_map(settings) and is_turn(turn) do
    put_in(settings, [@self_key, :major_turn], turn)
  end

  def set_minor_gap(settings, number)
      when is_map(settings) and is_positive_number(number) do
    put_in(settings, [@self_key, :minor_gap], number)
  end

  def set_minor_placement(settings, placement)
      when is_map(settings) and grid_placement(placement) do
    put_in(settings, [@self_key, :minor_placement], placement)
  end

  def set_minor_turn(settings, turn)
      when is_map(settings) and is_turn(turn) do
    put_in(settings, [@self_key, :minor_turn], turn)
  end
end
