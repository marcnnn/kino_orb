defmodule Kino.Orb do
  @moduledoc ~S'''
  A kino for rendering big graphs.


  ## Examples

  nodes = [
        %{ id: 1, label: "Orb" },
        %{ id: 2, label: "Graph" },
        %{ id: 3, label: "Canvas" },
      ]
  edges = [
        %{ id: 1, start: 1, end: 2, label: "DRAWS" },
        %{ id: 2, start: 2, end: 3, label: "ON" },
      ]
  Kino.Orb.new(%{nodes: nodes,edges: edges})


  count = 600

  nodes = [
        %{ id: 1, label: "Orb" },
        %{ id: 2, label: "Graph" },
        %{ id: 3, label: "Canvas" },
      ] ++ Enum.map(4..count, fn i ->
        %{ id: i, label: "#{i}"}
      end)
  edges = [
        %{ id: 1, start: 1, end: 2, label: "DRAWS" },
        %{ id: 2, start: 2, end: 3, label: "ON" },
      ] ++ Enum.map(4..count, fn i ->
        %{ id: i, start: 1, end: i, label: "#{i}"}
      end)
  Kino.Orb.new(%{nodes: nodes,edges: edges})

  '''

  use Kino.JS, assets_path: "lib/assets/orb/build"
  use Kino.JS.Live

  @type t :: Kino.JS.t()

  @doc """
  Creates a new kino displaying the given graph.
  """
  @spec new(binary()) :: t()
  def new(graph) do
    Kino.JS.Live.new(__MODULE__, graph)
  end

  @doc """
  Appends a single data point to the graphic dataset.

  ## Options

    * `:window` - the maximum number of data points to keep.
      This option is useful when you are appending new
      data points to the plot over a long period of time

    * `dataset` - name of the targeted dataset from
      the VegaLite specification. Defaults to the default
      anonymous dataset

  """
  @spec push(t(), map(), keyword()) :: :ok
  def push(kino, graph, _opts \\ []) do
    Kino.JS.Live.cast(kino, {:push, graph})
  end

  def pull(kino) do
    Kino.JS.Live.call(kino, :pull)
  end

  @impl true
  def init(graph, ctx) do
    {:ok, assign(ctx, orb: graph)}
  end

  @impl true
  def handle_connect(ctx) do
    {:ok, ctx.assigns.orb, ctx}
  end

  @impl true
  def handle_cast({:push, %{nodes: new_nodes, edges: new_edges}}, %Kino.JS.Live.Context{assigns: %{orb: %{nodes: nodes, edges: edges}}} = ctx) do
    nodes = new_nodes ++ nodes
    edges = new_edges ++ edges
    graph = %{nodes: nodes, edges: edges}
    broadcast_event(ctx, "push", graph)
    {:noreply, assign(ctx, orb: graph)}
  end

  def handle_call(:pull, _from, %Kino.JS.Live.Context{assigns: %{orb: graph}} = ctx) do
    {:reply, graph, ctx}
  end
end
