defmodule Chart.Gauge do
  @moduledoc """

  ![Gauge](docs/gauge.png)

  An appearance of gauge graph can be change via `config_keywords` (see below `setup/1` function)
  and/or `gauge.css`. This css file has to by imported into your `app.scss` in assets/css:

  `@import "../../../chart/priv/static/css/gauge.css";`

  Or can be copy/paste at your discretion wherever you want...

  """

  alias Chart.Gauge.{Settings, Svg}

  @type data() :: nil | number()
  @type t() :: %__MODULE__{
          settings: Settings.t(),
          data: data()
        }

  defstruct settings: %Settings{},
            data: nil

  @doc """
  This function serves for depicting values at gauge graph.

  In Phoenix LiveView is possible used it in e.g. `handle_info` function:
  ```
  def handle_info(:gen_val, socket) do
    g = Gauge.put(socket.assigns.gauge, Enum.random(0..300))

    {:noreply, assign(socket, gauge: g)}
  end
  ```
  """
  @spec put(Gauge.t(), data()) :: t()
  def put(%__MODULE__{} = gauge, data) do
    %{gauge | data: data}
  end

  @doc """
  It renders gauge graph in your page/template/component.

  In Phoenix LiveView is possible used it as:
  ```
  def render(assigns) do
    assigns = [gauge_graph: Gauge.render(assigns.gauge)]

    Phoenix.View.render(AppWeb.PageView, "page_live.html", assigns)
  end
  ```
  """
  @spec render(Gauge.t()) :: {:safe, iodata()}
  def render(%__MODULE__{} = gauge) do
    gauge |> Svg.generate()
  end

  @doc """
  Via this function you can change some properties of gauge graph.
  Others properties can be set via `gauge.css`.

  Only following keys are valid:
  ```
  config = [
    gauge_bottom_width_lines: 1.25,
    gauge_value_class: [],
    range: {0, 300},
    viewbox: {160, 80},
    major_ticks_count: 7,
    major_ticks_gap: 0,
    major_ticks_length: 5,
    major_ticks_value_decimals: 0,
    major_ticks_text_gap: 0,
    value_text_decimals: 0,
    thresholds: [],
    treshold_width: 1
  ]
  ```
  Also these values are set as default. Admissible values for following keys are
  ```
  gauge_value_class: [
    {[0, 50], "gauge-value-warning"},
    # ...
    {[50, 250], "gauge-value-normal"},
    # ...
    {[250, 300], "gauge-value-critical"}
  ]
  thresholds: [
    # ...
    {23, "treshold_low"},
    # ...
    {235, "treshold_high"}
    # ...
  ]
  ```
  where strings are class names.

  In Phoenix LiveView is possible used it in `mount` function:
  ```
  def mount(_params, _session, socket) do
    {:ok, assign(socket, gauge: Gauge.setup(config))}
  end
  ```
  """
  @spec setup(list()) :: t()
  def setup(config_keywords) do
    %__MODULE__{settings: Settings.set(config_keywords)}
  end
end
