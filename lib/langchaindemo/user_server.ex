defmodule Langchaindemo.UserServer do
  use GenServer
  require Logger

  defstruct [:chain, :user_id]

  def start_link(user_id) when is_integer(user_id) do
    Logger.debug("UserServer.start_link: user_id=#{user_id}")

    GenServer.start_link(
      __MODULE__,
      user_id,
      name: via_tuple(user_id)
    )
  end

  @spec run_prompt(non_neg_integer(), String.t()) :: String.t()
  def run_prompt(user_id, prompt) do
    GenServer.call(via_tuple(user_id), {:run_prompt, prompt})
  end

  # Callbacks
  @impl true
  def init(user_id) when is_integer(user_id) do
    Logger.debug("UserServer.init: user_id=#{user_id}")
    chain = Langchaindemo.new_chain()
    {:ok, %__MODULE__{chain: chain, user_id: user_id}}
  end

  # @impl true
  # def handle_cast({:put, key, value}, state) do
  #   {:noreply, Map.put(state, key, value)}
  # end

  @impl true
  def handle_call({:run_prompt, prompt}, _, %__MODULE__{user_id: user_id, chain: chain} = state) do
    Logger.debug("UserServer.handle_call: user_id=#{user_id} running prompt #{prompt}")

    case Langchaindemo.run_user_prompt(chain, prompt) do
      {:ok, new_chain} ->
        # update state
        new_state = %{state | chain: new_chain}

        # pull out the actual text response
        response_text = Langchaindemo.get_last_message(new_chain)

        Logger.debug("UserServer.handle_call: user_id=#{user_id}, response=#{response_text}")

        {:reply, response_text, new_state}

      {:error, _, reason} ->
        Logger.error("UserServer: user_id=#{user_id}, error=#{inspect(reason)}")
        {:reply, "There was an error", state}
    end
  end

  defp via_tuple(user_id) do
    Langchaindemo.ProcessRegistry.via_tuple({__MODULE__, user_id})
  end
end
