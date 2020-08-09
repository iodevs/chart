defmodule Chart.Internal.Guards do
  @moduledoc """
  A gurad helpers
  """
  defguard is_positive_number(number) when is_number(number) and 0 < number
  defguard is_range(min, max) when is_number(min) and is_number(max) and min < max
  defguard turn(t) when t in [:on, :off]
end
