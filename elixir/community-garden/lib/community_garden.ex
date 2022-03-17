# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  def start(opts \\ []), do: Agent.start(fn -> [] end, opts)

  def list_registrations(pid), do: Agent.get(pid, & &1)

  def register(pid, register_to) do 
    plot = %Plot{plot_id: 1, registered_to: register_to}
    Agent.update(pid, &[plot | &1])
    plot
  end

  def release(pid, plot_id) do
    Agent.update(pid, fn plots ->
      Enum.reject(plots, &match_plot_id(&1, plot_id))
    end)
  end

  def get_registration(pid, plot_id) do
    Agent.get(pid, fn plots ->
      Enum.find(plots, {:not_found, "plot is unregistered"}, &match_plot_id(&1, plot_id))
    end)
  end

  defp match_plot_id(%Plot{plot_id: plot_id}, id), do: plot_id == id
end
