defmodule Chart.Internal.MajorTicksText do
  @moduledoc false

  alias Chart.Internal.{Utils, Validators}
  alias ExMaybe, as: Maybe

  @type format() :: {:decimals, non_neg_integer()} | {:datetime, String.t()}

  @self_key :major_ticks_text

  defstruct format: nil,
            gap: nil,
            labels: nil,
            positions: nil

  def new() do
    %{
      format: {:decimals, 0},
      gap: 0,
      labels: [],
      positions: []
    }
  end

  def add(settings, key) when is_map(settings) and is_atom(key) do
    put_in(settings, [key, @self_key], new())
  end

  def put_format(settings, key, {:decimals, dec} = lf)
      when is_map(settings) and is_atom(key) and is_integer(dec) and 0 <= dec do
    put_in(settings, [key, @self_key, :format], lf)
  end

  def put_format(settings, key, {:datetime, dt} = lf)
      when is_map(settings) and is_atom(key) and is_binary(dt) do
    put_in(settings, [key, @self_key, :format], lf)
  end

  def put_gap(settings, key, gap) when is_map(settings) and is_atom(key) and is_number(gap) do
    put_in(settings, [key, @self_key, :gap], gap)
  end

  def put_labels(settings, key, labels)
      when is_map(settings) and is_atom(key) and is_list(labels) do
    put_in(settings, [key, @self_key, :labels], labels)
  end
end
