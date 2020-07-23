defmodule Chart.Utils do
  @moduledoc false

  def key_guard(kw, key, default_val, fun) do
    fun.(Keyword.get(kw, key, default_val))
  end
end
