defmodule Utils do
  @moduledoc """
  Documentation for `Utils`.
  """
  alias Utils.ValidatedForm

  def animate(:remainder) do
    Kino.animate(500, 0, fn i ->
      md = Kino.Markdown.new("
  ```elixir
  rem(#{i}, 10) = #{rem(i, 10)}
  ```
  ")

      {:cont, md, i + 1}
    end)
  end

  @doc ~S"""
  iex> %Kino.JS{} = Utils.form(:comparison_operators)
  iex> %Kino.JS{} = Utils.form(:boolean_fill_in_the_blank)
  """

  def form(:comparison_operators) do
    ValidatedForm.new([
      %{label: "7 __ 8", answers: ["<"]},
      %{label: "8 __ 7", answers: [">"]},
      %{label: "8 __ 8 and 9 __ 9 and not 10 __ 10.0", answers: ["==="]},
      %{label: "8 __ 8.0 and 0 __ 9.0", answers: ["=="]},
      %{label: "8 __ 7 and 7 __ 7", answers: [">="]},
      %{label: "7 __ 8 and 7 __ 7", answers: ["<="]}
    ])
  end

  def form(:boolean_fill_in_the_blank) do
    ValidatedForm.new([
      %{label: "not ____ and true === false", answers: ["true"]},
      %{label: "true ____ false === true", answers: ["or"]},
      %{label: "not true ____ true === true", answers: ["or"]},
      %{label: "not false ____ true === true", answers: ["and"]},
      %{label: "not (true and false) ____ false === true", answers: ["or"]},
      %{label: "not (true or false) or not (not ____ and true) === true", answers: ["false"]},
      %{label: "____ false and true === true", answers: ["not"]},
      %{label: "false or ____ true === false", answers: ["not"]}
    ])
  end

  @doc ~S"""
  iex> :ok = Utils.graph(:binary_search)
  """
  def graph(:binary_search) do
    size = 600

    widget =
      VegaLite.new(width: size, height: size)
      |> VegaLite.mark(:line)
      |> VegaLite.encode_field(:x, "number of elements", type: :quantitative)
      |> VegaLite.encode_field(:y, "time", type: :quantitative)
      |> VegaLite.transform(groupby: ["color"], extent: [2500, 6500])
      |> VegaLite.encode_field(:color, "type", title: "Big O Notation", type: :nominal)
      |> Kino.VegaLite.new()
      |> Kino.render()

    init = 1
    max = 500

    logn = for n <- init..max, do: %{"number of elements": n, time: :math.log2(n), type: "log(n)"}

    Kino.VegaLite.push_many(widget, logn)
  end

  @doc ~S"""
  iex> %Kino.Markdown{} = Utils.visual(:loading_bar, 50)
  iex> %Kino.Image{} = Utils.visual(:light_control, true)
  """
  def visual(:loading_bar, percentage) do
    Kino.Markdown.new("
    <div style=\"height: 20px; width: 100%; background-color: grey\">
      <div style=\"height: 20px; width: #{percentage}%; background-color: green\"></div>
    </div>
  ")
  end

  def visual(:light_control, power) do
    content = if power, do: "/images/on.png", else: "/images/off.png"
    image = Kino.Image.new(File.read!(__DIR__ <> content), :png)
  end

  def visual(:comparison_examples) do
    Kino.DataTable.new([
      %{comparison: "5 === 5", result: true},
      %{comparison: "5 === 5.0", result: false},
      %{comparison: "5 == 5.0", result: true},
      %{comparison: "5 === 4", result: false},
      %{comparison: "5 > 4", result: true},
      %{comparison: "4 > 5", result: false},
      %{comparison: "5 < 4", result: false},
      %{comparison: "4 < 5", result: true},
      %{comparison: "5 >= 5", result: true},
      %{comparison: "5 >= 4", result: true},
      %{comparison: "4 >= 5", result: false},
      %{comparison: "5 <= 5", result: true},
      %{comparison: "4 <= 5", result: true},
      %{comparison: "5 <= 4", result: false}
    ])
  end
end
