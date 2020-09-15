defmodule Chart.Internal.AxisLine.MajorTicksText do
  @moduledoc false

  alias Chart.Internal.Utils
  import Chart.Internal.Guards, only: [is_decimals: 1, is_nonnegative_number: 1, is_range: 2]

  @self_key :major_ticks_text

  def new() do
    %{
      format: {:decimals, 1},
      gap: 0,
      labels: [],
      positions: [],
      offset_range: {0, 0},
      range: {0, 1}
    }
  end

  def add(%{axis_table: axis_table} = settings, axis)
      when is_map(settings) and is_map_key(axis_table, axis) do
    settings
    |> put_in([axis, @self_key], new())
    |> set_positions(axis)
    |> set_labels(axis)
  end

  # Setters

  @doc """
  format :: {:decimals, non_neg_integer()} | {:datetime, String.t()}
  """
  def set_format(%{axis_table: axis_table} = settings, axis, {:datetime, dt} = format)
      when is_map(settings) and is_map_key(axis_table, axis) and is_binary(dt) do
    now = DateTime.utc_now() |> DateTime.to_unix()

    settings
    |> put_in([axis, @self_key, :format], validate_format(format))
    |> set_range(axis, {now - 60, now})
  end

  def set_format(%{axis_table: axis_table} = settings, axis, format)
      when is_map(settings) and is_map_key(axis_table, axis) do
    settings
    |> put_in([axis, @self_key, :format], validate_format(format))
    |> set_labels(axis)
  end

  @doc """
  gap ::  number
  """
  def set_gap(%{axis_table: axis_table} = settings, axis, gap)
      when is_map(settings) and is_map_key(axis_table, axis) and is_number(gap) do
    put_in(settings, [axis, @self_key, :gap], gap)
  end

  @doc """
  range :: tuple(number(), number())
  """
  def set_labels(%{axis_table: axis_table} = settings, axis)
      when is_map(settings) and is_map_key(axis_table, axis) do
    settings_ax = settings[axis]
    format = settings_ax.major_ticks_text.format

    labels =
      compute_labels(
        settings_ax.major_ticks_text.range,
        settings_ax.major_ticks.count + 1,
        settings_ax.scale,
        format
      )
      |> apply_format(format)

    put_in(settings, [axis, @self_key, :labels], labels)
  end

  def set_positions(settings, vector) when is_map(settings) and is_tuple(vector) do
    axis = settings.axis_table |> Utils.get_axis_for_vector(vector)

    set_positions(settings, axis)
  end

  def set_positions(%{axis_table: axis_table} = settings, axis)
      when is_map(settings) and is_map_key(axis_table, axis) do
    put_in(settings, [axis, @self_key, :positions], settings[axis].major_ticks.positions)
  end

  def set_range(settings, vector, {from, to} = range)
      when is_map(settings) and is_tuple(vector) and is_range(from, to) do
    axis = settings.axis_table |> Utils.get_axis_for_vector(vector)

    set_range(settings, axis, range)
  end

  def set_range(%{axis_table: axis_table} = settings, axis, {from, to} = range)
      when is_map(settings) and is_map_key(axis_table, axis) and is_range(from, to) do
    range = compute_range(range, settings[axis][@self_key][:offset_range])

    settings
    |> put_in([axis, @self_key, :range], range)
    |> set_labels(axis)
  end

  def set_range_offset(settings, axis, :auto) when is_map(settings) do
    put_in(settings, [axis, @self_key, :offset_range], :auto)
  end

  def set_range_offset(settings, axis, offset_range)
      when is_map(settings) and is_tuple(offset_range) do
    put_in(settings, [axis, @self_key, :offset_range], offset_range)
  end

  def set_range_offset(settings, axis, offset)
      when is_map(settings) and is_nonnegative_number(offset) do
    put_in(settings, [axis, @self_key, :offset_range], {offset, offset})
  end

  # Private

  defp apply_format(labels, {:decimals, dec}) do
    Enum.map(labels, &Utils.round_value(&1, dec))
  end

  defp apply_format(labels, {:datetime, dt}) do
    Enum.map(labels, &Utils.datetime_format(&1, dt))
  end

  defp compute_labels(range, count, :linear, {:decimals, _dec}) do
    Utils.linspace(range, count)
  end

  defp compute_labels(range, count, :log, {:decimals, _dec}) do
    Utils.logspace(range, count)
  end

  defp compute_labels(range, count, :linear, {:datetime, _dt}) do
    Utils.linspace(range, count)
  end

  defp compute_range(range, :auto) do
    add_offset_to_range(range)
  end

  defp compute_range({from, to}, {offset_from, offset_to}) do
    {from - offset_from, to + offset_to}
  end

  defp validate_format({:decimals, dec} = format) when is_decimals(dec) do
    format
  end

  defp validate_format({:datetime, dt} = format) when is_binary(dt) do
    format
  end

  defp add_offset_to_range({min, max}) when 0 < min do
    {0, max + offset(max)}
  end

  defp add_offset_to_range({min, max}) do
    {min - offset(min), max + offset(max)}
  end

  defp offset(num) do
    log10 = num |> :erlang.abs() |> :math.log10()

    exp =
      if log10 < 1 do
        Float.floor(log10)
      else
        Float.floor(log10) - 1
      end

    :math.pow(10, exp)
  end
end
