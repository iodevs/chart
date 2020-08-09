defmodule Chart.Internal.Label do
  @moduledoc false
  alias Chart.Internal.Text

  def add(settings, key) when is_map(settings) do
    put_in(settings, [key, :label], Text.new())
  end
end
