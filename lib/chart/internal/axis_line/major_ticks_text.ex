defmodule Chart.Internal.AxisLine.MajorTicksText do
  @moduledoc false

  alias Chart.Internal.AxisLine.Helpers
  import Chart.Internal.Guards, only: [is_decimals: 1, is_numbers: 2]

  @self_key :major_ticks_text

  def new() do
    %{
      format: {:decimals, 1},
      gap: 0,
      labels: [],
      positions: [],
      range: {0, 1}
    }
  end

  def add(settings, axis) when is_map(settings) and is_atom(axis) do
    put_in(settings, [axis, @self_key], new())
  end

  # Setters

  @doc """
  format :: {:decimals, non_neg_integer()} | {:datetime, String.t()}
  """
  def set_format(settings, axis, format) when is_map(settings) and is_atom(axis) do
    put_in(settings, [axis, @self_key, :format], validate_format(format))
  end

  @doc """
  gap ::  number
  """
  def set_gap(settings, axis, gap) when is_map(settings) and is_atom(axis) and is_number(gap) do
    put_in(settings, [axis, @self_key, :gap], gap)
  end

  @doc """
  labels :: list(number()) | list(String.t())
  """
  def set_labels(settings, axis, {from, to} = range)
      when is_map(settings) and is_atom(axis) and is_numbers(from, to) do
    settings
    |> put_in([axis, @self_key, :range], range)
    |> Helpers.recalculate_ticks_labels(axis)
  end

  # Private

  defp validate_format({:decimals, dec} = format) when is_decimals(dec) do
    format
  end

  defp validate_format({:datetime, dt} = format) when is_binary(dt) do
    format
  end
end
