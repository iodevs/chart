defmodule Chart.SomeChart.Settings do
  @moduledoc """
  A chart settings.
  """

  alias Chart.Internal.{
    Axis,
    Figure,
    Grid,
    Label,
    MajorTicks,
    MajorTicksText,
    MinorTicks,
    Plot,
    Title
  }

  def new() do
    %{}
    |> Figure.add()
    |> Title.add()
    |> Plot.add()
    |> Grid.add()
    |> axis(:x_axis)
    |> axis(:y_axis)
  end

  def axis(settings, key) when is_map(settings) do
    settings
    |> Axis.add(key)
    |> Label.add(key)
    |> MajorTicks.add(key)
    |> MajorTicksText.add(key)
    |> MinorTicks.add(key)
  end
end
