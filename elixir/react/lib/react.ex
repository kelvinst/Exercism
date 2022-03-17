defmodule React do
  use GenServer

  defstruct inputs: %{}, computes: [], callbacks: %{}, values: %{}

  @opaque cells :: pid

  @type cell :: {:input, String.t(), any} | {:output, String.t(), [String.t()], fun()}

  @doc """
  Start a reactive system
  """
  @spec new(cells :: [cell]) :: {:ok, pid}
  def new(cells), do: GenServer.start(React, cells)

  @doc """
  Return the value of an input or output cell
  """
  @spec get_value(cells :: pid, cell_name :: String.t()) :: any()
  def get_value(cells, cell_name), do: GenServer.call(cells, {:get, cell_name})

  @doc """
  Set the value of an input cell
  """
  @spec set_value(cells :: pid, cell_name :: String.t(), value :: any) :: :ok
  def set_value(cells, cell_name, value), do: GenServer.cast(cells, {:set, cell_name, value})

  @doc """
  Add a callback to an output cell
  """
  @spec add_callback(
          cells :: pid,
          cell_name :: String.t(),
          callback_name :: String.t(),
          callback :: fun()
        ) :: :ok
  def add_callback(cells, cell_name, callback_name, callback) do
    GenServer.cast(cells, {:add_callback, cell_name, callback_name, callback})
  end

  @doc """
  Remove a callback from an output cell
  """
  @spec remove_callback(cells :: pid, cell_name :: String.t(), callback_name :: String.t()) :: :ok
  def remove_callback(cells, cell_name, callback_name) do
    GenServer.cast(cells, {:remove_callback, cell_name, callback_name})
  end

  @impl GenServer
  def init(cells) do
    {inputs, computes} = Enum.split_with(cells, &(elem(&1, 0) == :input))

    state = %React{
      inputs: inputs |> Enum.map(&Tuple.delete_at(&1, 0)) |> Enum.into(%{}),
      computes: computes |> Enum.map(&Tuple.delete_at(&1, 0))
    }

    {:ok, compute(state)}
  end

  defp compute(state) do
    %{
      state
      | values:
          Enum.reduce(state.computes, state.inputs, fn {name, fields, fun}, acc ->
            new_value = apply(fun, Enum.map(fields, &acc[&1]))

            if new_value != state.values[name] do
              for {callback_name, callback} <- state.callbacks[name] || [] do
                callback.(callback_name, new_value)
              end
            end

            Map.put(acc, name, new_value)
          end)
    }
  end

  @impl GenServer
  def handle_call({:get, name}, _, state), do: {:reply, state.values[name], state}

  @impl GenServer
  def handle_cast({:set, name, value}, state) do
    new_state = %{
      state
      | inputs: Map.put(state.inputs, name, value)
    }

    {:noreply, compute(new_state)}
  end

  def handle_cast({:add_callback, cell_name, callback_name, callback}, state) do
    new_state = %{
      state
      | callbacks:
          Map.update(
            state.callbacks,
            cell_name,
            %{callback_name => callback},
            &Map.put(&1, callback_name, callback)
          )
    }

    {:noreply, new_state}
  end

  def handle_cast({:remove_callback, cell_name, callback_name}, state) do
    {_, new_callbacks} = pop_in(state.callbacks, [cell_name, callback_name])
    new_state = %{state | callbacks: new_callbacks}
    {:noreply, new_state}
  end
end
