defmodule Chart.Internal.Plot do
  @moduledoc false

  alias Chart.Internal.Rectangle
  alias Chart.Internal.AxisLine.{Label, MajorTicks, MajorTicksText, MinorTicks}
  alias Chart.Internal.AxisLine

  import Chart.Internal.Guards, only: [is_positive_number: 1]

  @self_key :plot

  def add(settings) when is_map(settings) do
    settings
    |> Rectangle.add(@self_key)
    |> Rectangle.set_position(@self_key, {100, 100})
    |> Rectangle.set_size(@self_key, {600, 400})
  end

  # Setters

  def set_position(settings, {x, y} = position)
      when is_map(settings) and is_positive_number(x) and is_positive_number(y) do
    settings
    |> Rectangle.set_position(
      @self_key,
      validate_position(position, settings.figure.viewbox, settings.plot.size)
    )
    |> AxisLine.set_line(:x_axis)
    |> AxisLine.set_line(:y_axis)
    |> MajorTicks.set_positions({1, 0})
    |> MajorTicks.set_positions({0, 1})
    |> MinorTicks.set_positions({1, 0})
    |> MinorTicks.set_positions({0, 1})
    |> MajorTicksText.set_positions({1, 0})
    |> MajorTicksText.set_positions({0, 1})
    |> Label.set_position({1, 0})
    |> Label.set_position({0, 1})
  end

  def set_background_padding(settings, padding) do
    Rectangle.set_padding(settings, @self_key, padding)
  end

  def set_size(settings, {x, y} = size)
      when is_map(settings) and is_positive_number(x) and is_positive_number(y) do
    settings
    |> Rectangle.set_size(@self_key, validate_size(size, settings.figure.viewbox))
    |> AxisLine.set_line(:x_axis)
    |> AxisLine.set_line(:y_axis)
    |> MajorTicks.set_positions({1, 0})
    |> MajorTicks.set_positions({0, 1})
    |> MinorTicks.set_positions({1, 0})
    |> MinorTicks.set_positions({0, 1})
    |> MajorTicksText.set_positions({1, 0})
    |> MajorTicksText.set_positions({0, 1})
    |> Label.set_position({1, 0})
    |> Label.set_position({0, 1})
  end

  # Private

  defp validate_position(
         {pos_x, pos_y} = position,
         {fig_width, fig_height},
         {plot_width, plot_height}
       )
       when pos_x + plot_width < fig_width and pos_y + plot_height < fig_height do
    position
  end

  defp validate_size({width, height} = size, {fig_width, fig_height})
       when width < fig_width and height < fig_height do
    size
  end
end
