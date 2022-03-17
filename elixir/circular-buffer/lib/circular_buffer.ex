defmodule CircularBuffer do
  @moduledoc """
  An API to a stateful process that fills and empties a circular buffer
  """

  @doc """
  Create a new buffer of a given capacity
  """
  @spec new(capacity :: integer) :: {:ok, pid}
  def new(capacity) do
    Agent.start(fn -> empty(capacity) end)
  end

  defp empty(capacity) do
    %{
      count: 0,
      write: 0,
      read: 0,
      capacity: capacity, 
      data: Tuple.duplicate(nil, capacity)
    } 
  end

  @doc """
  Read the oldest entry in the buffer, fail if it is empty
  """
  @spec read(buffer :: pid) :: {:ok, any} | {:error, atom}
  def read(buffer) do
    Agent.get_and_update(buffer, fn 
      %{count: 0} = state -> 
        {{:error, :empty}, state}

      state -> 
        result = {:ok, elem(state.data, state.read)}
        new_state = %{
          state |
          data: put_elem(state.data, state.read, nil),
          read: next_index(state.read, state.capacity),
          count: state.count - 1
        }

        {result, new_state}
    end)
  end

  @doc """
  Write a new item in the buffer, fail if is full
  """
  @spec write(buffer :: pid, item :: any) :: :ok | {:error, atom}
  def write(buffer, item) do
    Agent.get_and_update(buffer, fn 
      %{count: c, capacity: c} = state -> {{:error, :full}, state}
      state -> {:ok, do_write(state, item)}
    end)
  end

  @doc """
  Write an item in the buffer, overwrite the oldest entry if it is full
  """
  @spec overwrite(buffer :: pid, item :: any) :: :ok
  def overwrite(buffer, item) do
    Agent.get_and_update(buffer, fn 
      %{count: c, capacity: c} = state -> {:ok, do_overwrite(state, item)}
      state -> {:ok, do_write(state, item)}
    end)
  end

  defp do_overwrite(state, item) do
    %{
      state |
      data: put_elem(state.data, state.write, item),
      write: next_index(state.write, state.capacity),
      read: next_index(state.read, state.capacity)
    }
  end

  defp do_write(state, item) do
    %{
      state |
      data: put_elem(state.data, state.write, item),
      write: next_index(state.write, state.capacity),
      count: state.count + 1
    }
  end

  defp next_index(i, c) when i + 1 == c, do: 0
  defp next_index(i, _), do: i + 1

  @doc """
  Clear the buffer
  """
  @spec clear(buffer :: pid) :: :ok
  def clear(buffer) do
    Agent.update(buffer, fn state -> empty(state.capacity) end)
  end
end
