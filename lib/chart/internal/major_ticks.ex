defmodule Chart.Internal.MajorTicks do
  @moduledoc false

  alias Chart.Internal.Utils

  import Chart.Internal.Guards,
    only: [
      is_positive_number: 1,
      is_range: 2
    ]

  @self_key :major_ticks

  def new() do
    %{
      count: 7,
      gap: 0,
      length: 0.5,
      range: {0, 1},
      positions: []
    }
  end

  def add(settings, key) when is_map(settings) and is_atom(key) do
    put_in(settings, [key, @self_key], new())
  end

  def linear(settings, key) when is_map(settings) and is_atom(key) do
    major_ticks = settings[key].major_ticks

    lst = Utils.linspace(major_ticks.range, major_ticks.count)

    put_in(settings, [key, @self_key, :positions], lst)
  end

  def log(settings, key) when is_map(settings) and is_atom(key) do
    major_ticks = settings[key].major_ticks

    lst = Utils.logspace(major_ticks.range, major_ticks.count)

    put_in(settings, [key, @self_key, :positions], lst)
  end

  def put_count(settings, key, count)
      when is_map(settings) and is_atom(key) and is_integer(count) and count > 1 do
    put_in(settings, [key, @self_key, :count], count)
  end

  def put_gap(settings, key, gap) when is_map(settings) and is_atom(key) and is_number(gap) do
    put_in(settings, [key, @self_key, :gap], gap)
  end

  def put_length(settings, key, length)
      when is_map(settings) and is_atom(key) and is_positive_number(length) do
    put_in(settings, [key, @self_key, :length], length)
  end

  def put_range(settings, key, {min, max} = range)
      when is_map(settings) and is_atom(key) and is_range(min, max) do
    put_in(settings, [key, @self_key, :range], range)
  end
end
