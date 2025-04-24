defmodule Langchaindemo.UserServer do
  use GenServer

  def start_link(user_id) when is_integer(user_id) do
    GenServer.start_link(
      __MODULE__,
      nil,
      name: via_tuple(user_id)
    )
  end

  def put(user_id, key, value) do
    GenServer.cast(via_tuple(user_id), {:put, key, value})
  end

  def get(user_id, key) do
    GenServer.call(via_tuple(user_id), {:get, key})
  end

  # Callbacks
  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  @impl true
  def handle_call({:get, key}, _, state) do
    {:reply, Map.get(state, key), state}
  end

  defp via_tuple(user_id) do
    Langchaindemo.ProcessRegistry.via_tuple({__MODULE__, user_id})
  end
end
