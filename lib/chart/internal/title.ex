defmodule Chart.Internal.Title do
  @moduledoc false

  alias Chart.Internal.Text

  def add(settings) when is_map(settings) do
    Map.put(settings, :title, Text.new())
  end
end
