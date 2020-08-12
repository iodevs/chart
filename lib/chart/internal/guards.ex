defmodule Chart.Internal.Guards do
  @moduledoc """
  A gurad helpers
  """

  defguard is_decimals(d) when is_integer(d) and 0 <= d
  defguard is_nonnegative_number(x) when is_number(x) and 0 <= x
  defguard is_nonnegative_number(x, y) when is_number(x) and is_number(y) and 0 <= x and 0 <= y
  defguard is_number(x, y) when is_number(x) and is_number(y)
  defguard is_positive_number(number) when is_number(number) and 0 < number
  defguard is_positive_number(x, y) when is_number(x) and is_number(y) and 0 < x and 0 < y
  defguard is_range(min, max) when is_number(min) and is_number(max) and min < max
  defguard is_turn(t) when t in [:on, :off]
end
