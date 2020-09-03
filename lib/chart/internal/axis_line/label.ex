defmodule Chart.Internal.AxisLine.Label do
  @moduledoc false

  alias Chart.Internal.Rectangle
  alias Chart.Internal.Utils

  import Chart.Internal.Guards, only: [is_positive_number: 1]

  @self_key :label
  @gap_from_bottom 60
  @gap_from_left 70

  defguard label_placement(pl) when pl in [:left, :center, :right, :top, :middle, :bottom]

  def new() do
    %{
      adjust_placement: {0, 0},
      placement: :center,
      position: {0, 0},
      rect_bg: nil,
      text: ""
    }
  end

  def add(%{axis_table: axis_table} = settings, axis)
      when is_map(settings) and is_map_key(axis_table, axis) do
    settings
    |> put_in([axis, @self_key], new())
    |> set_position(axis)
  end

  def add_rect_bg(%{axis_table: axis_table} = settings, axis)
      when is_map(settings) and is_map_key(axis_table, axis) do
    rect_bg =
      Rectangle.new()
      |> Map.take([:size])
      |> Map.put(:position, settings[axis][@self_key].position)

    put_in(settings, [axis, @self_key, :rect_bg], rect_bg)
  end

  # Setters

  @doc """
  adjust_placement :: {number, number}
  """
  def set_adjust_placement(%{axis_table: axis_table} = settings, axis, {x, y} = adjust_placement)
      when is_map(settings) and is_map_key(axis_table, axis) and
             is_number(x) and is_number(y) do
    settings
    |> put_in([axis, @self_key, :adjust_placement], adjust_placement)
    |> set_position(axis)
  end

  def set_position(settings, vector) when is_map(settings) and is_tuple(vector) do
    axis = settings.axis_table |> Utils.get_axis_for_vector(vector)

    set_position(settings, axis)
  end

  def set_position(%{axis_table: axis_table} = settings, axis)
      when is_map(settings) and is_map_key(axis_table, axis) do
    label = settings[axis][@self_key]

    position =
      compute_label_position(
        label.placement,
        label.adjust_placement,
        settings.plot.position,
        settings.plot.size
      )

    settings
    |> put_in([axis, @self_key, :position], position)
    |> set_rect_bg_position(axis, position, label.rect_bg)
  end

  @doc """
  placement :: :left | :center | :right | :top | :middle | :bottom
  """
  def set_placement(%{axis_table: axis_table} = settings, axis, placement)
      when is_map(settings) and is_map_key(axis_table, axis) and is_atom(placement) do
    settings
    |> put_in([axis, @self_key, :placement], placement)
    |> set_position(axis)
  end

  def set_text(%{axis_table: axis_table} = settings, axis, text)
      when is_map(settings) and is_map_key(axis_table, axis) and is_binary(text) do
    put_in(settings, [axis, @self_key, :text], text)
  end

  def set_rect_bg_size(%{axis_table: axis_table} = settings, axis, {w, h} = size)
      when is_map(settings) and is_map_key(axis_table, axis) and is_positive_number(w) and
             is_positive_number(h) do
    put_in(settings, [axis, @self_key, :rect_bg, :size], size)
  end

  # Private

  defp set_rect_bg_position(settings, _axis, _position, nil), do: settings

  defp set_rect_bg_position(%{axis_table: axis_table} = settings, axis, position, _rect)
       when is_map(settings) and is_map_key(axis_table, axis) and is_tuple(position) do
    put_in(settings, [axis, @self_key, :rect_bg, :position], position)
  end

  # compute_label_position(placement, adjust_placement, plot_position, plot_size)
  defp compute_label_position(:left, {ad_pl_x, ad_pl_y}, {pos_x, pos_y}, {_width, height}) do
    {pos_x + ad_pl_x, pos_y + height + @gap_from_bottom + ad_pl_y}
  end

  defp compute_label_position(:center, {ad_pl_x, ad_pl_y}, {pos_x, pos_y}, {width, height}) do
    {pos_x + width / 2 + ad_pl_x, pos_y + height + @gap_from_bottom + ad_pl_y}
  end

  defp compute_label_position(:right, {ad_pl_x, ad_pl_y}, {pos_x, pos_y}, {width, height}) do
    {pos_x + width + ad_pl_x, pos_y + height + @gap_from_bottom + ad_pl_y}
  end

  defp compute_label_position(:top, {ad_pl_x, ad_pl_y}, {pos_x, pos_y}, {_width, _height}) do
    {pos_x - @gap_from_left + ad_pl_x, pos_y + ad_pl_y}
  end

  defp compute_label_position(:middle, {ad_pl_x, ad_pl_y}, {pos_x, pos_y}, {_width, height}) do
    {pos_x - @gap_from_left + ad_pl_x, pos_y + height / 2 + ad_pl_y}
  end

  defp compute_label_position(:bottom, {ad_pl_x, ad_pl_y}, {pos_x, pos_y}, {_width, height}) do
    {pos_x - @gap_from_left + ad_pl_x, pos_y + height + ad_pl_y}
  end
end
