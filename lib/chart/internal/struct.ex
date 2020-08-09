defmodule Chart.Internal.Struct do
  @moduledoc """
  A struct helpers.
  """

  alias ExMaybe, as: Maybe

  def new(%_{} = settings, kw, lookup) when is_list(kw) and is_map(lookup) do
    settings
    |> Map.from_struct()
    |> Enum.reduce(settings, &update(&1, &2, kw, lookup))
  end

  def put(%_{} = data, key, value, lookup) when is_atom(key) and is_map(lookup) do
    {_, f} = Map.get(lookup, key, {nil, fn x -> x end})

    Map.put(data, key, f.(value))
  end

  defp update({key, value}, acc, config, validate) do
    {config_key, f} = Map.get(validate, key, {key, fn val -> val end})

    value =
      config
      |> Keyword.get(config_key)
      |> Maybe.map(f)
      |> Maybe.with_default(value)

    Map.put(acc, key, value)
  end
end
