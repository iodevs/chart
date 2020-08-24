defmodule Chart.Internal.AxisLine.Label do
  @moduledoc false

  alias Chart.Internal.Utils
  import Chart.Internal.Guards, only: [is_visibility: 1]

  @self_key :label
  @gap_from_bottom 60
  @gap_from_left 70

  defguard label_placement(pl) when pl in [:left, :center, :right, :top, :middle, :bottom]

  def new() do
    %{
      adjust_placement: {0, 0},
      placement: :center,
      rect_bg: nil,
      visibility: :visible,
      text: "",
      position: {0, 0}
    }
  end

  def add(settings, axis) when is_map(settings) and is_atom(axis) do
    settings
    |> put_in([axis, @self_key], new())
    |> set_position(axis)
  end

  # Setters

  @doc """
  adjust_placement :: {number, number}
  """
  def set_adjust_placement(settings, axis, {x, y} = adjust_placement)
      when is_map(settings) and is_atom(axis) and is_number(x) and is_number(y) do
    settings
    |> put_in([axis, @self_key, :adjust_placement], adjust_placement)
    |> set_position(axis)
  end

  def set_position(settings, vector) when is_map(settings) and is_tuple(vector) do
    axis = settings.axis_table |> Utils.get_axis_for_vector(vector)

    set_position(settings, axis)
  end

  def set_position(settings, axis) when is_map(settings) and is_atom(axis) do
    label = settings[axis].label

    position =
      compute_label_position(
        label.placement,
        label.adjust_placement,
        settings.plot.position,
        settings.plot.size
      )

    put_in(settings, [axis, @self_key, :position], position)
  end

  @doc """
  placement :: :left | :center | :right | :top | :middle | :bottom
  """
  def set_placement(settings, axis, placement)
      when is_map(settings) and is_atom(axis) and is_atom(placement) do
    settings
    |> put_in([axis, @self_key, :placement], placement)
    |> set_position(axis)
  end

  @doc """
  rect_bg :: :visible | :none
  """
  def set_rect_bg(settings, axis, rect_bg)
      when is_map(settings) and is_visibility(rect_bg) do
    put_in(settings, [axis, @self_key, :rect_bg], rect_bg)
  end

  @doc """
  visibility :: :visible | :none
  """
  def set_visibility(settings, axis, visibility)
      when is_map(settings) and is_visibility(visibility) do
    put_in(settings, [axis, @self_key, :visibility], visibility)
  end

  def set_text(settings, axis, text)
      when is_map(settings) and is_atom(axis) and is_binary(text) do
    put_in(settings, [axis, @self_key, :text], text)
  end

  # Private

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
