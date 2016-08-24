defmodule MyWedding.InlineSvgCache do
  use GenServer

  alias PhoenixInlineSvg.Helpers

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  ## Client API

  def svg_image(conn, svg, collection \\ nil) do
    svg_name = "#{collection}/#{svg}"

    case lookup(svg_name) do
      {:ok, data} ->
        data
      {:error} ->
        data =
          if collection != nil do
            Helpers.svg_image(conn, svg, collection)
          else
            Helpers.svg_image(conn, svg)
          end

        insert(svg_name, data)

        data
    end
  end

  def lookup(name) do
    GenServer.call(__MODULE__, {:lookup, name})
  end

  def insert(name, data) do
    GenServer.cast(__MODULE__, {:insert, name, data})
  end

  ## Server Callbacks

  def init(_) do
    :ets.new(:svg_image, [:named_table, read_concurrency: true])

    {:ok, %{}}
  end

  def handle_call({:lookup, name}, _from, state) do
    data =
      case :ets.lookup(:svg_image, name) do
        [{^name, data}] -> {:ok, data}
        [] -> {:error}
      end

    {:reply, data, state}
  end

  def handle_cast({:insert, name, data}, state) do
    :ets.insert(:svg_image, {name, data})

    {:noreply, state}
  end
end
