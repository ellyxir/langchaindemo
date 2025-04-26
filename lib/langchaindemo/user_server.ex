defmodule Langchaindemo.UserServer do
  use GenServer
  require Logger

  defstruct [:chain, :user_id]

  # how long we'll wait for the LLM to respond
  @max_llm_wait_ms 30_0000

  def start_link(user_id) when is_integer(user_id) do
    Logger.debug("UserServer.start_link: user_id=#{user_id}")

    GenServer.start_link(
      __MODULE__,
      user_id,
      name: via_tuple(user_id)
    )
  end

  @doc """
  this should return a map based on the json schema specified in the system prompt
  keys should be `Langchaindemo.message_content_key()` and `Langchaindemo.message_state_key()`
  TODO: make this a defstruct , dont like random string keys passed around
  """
  @spec run_prompt(non_neg_integer(), String.t()) :: {:ok, map()} | {:error, :timeout}
  def run_prompt(user_id, prompt) do
    try do
      {:ok, GenServer.call(via_tuple(user_id), {:run_prompt, prompt}, @max_llm_wait_ms)}
    catch
      :exit, {:timeout, _details} ->
        {:error, :timeout}
    end
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
  def handle_call(
        {:run_prompt, prompt},
        _,
        %__MODULE__{user_id: user_id, chain: %LangChain.Chains.LLMChain{} = chain} = state
      ) do
    Logger.debug("UserServer.handle_call: user_id=#{user_id} running prompt #{prompt}")

    case Langchaindemo.run_user_prompt(chain, prompt) do
      {:ok, new_chain} ->
        # update state
        new_state = %{state | chain: new_chain}
        response_content = Langchaindemo.get_last_message(new_chain)

        Logger.debug(
          "UserServer.handle_call: user_id=#{user_id}, response=#{inspect(response_content)}"
        )

        {:reply, response_content, new_state}

      {:error, _, reason} ->
        Logger.error("UserServer: user_id=#{user_id}, error=#{inspect(reason)}")
        {:reply, "There was an error: #{inspect(reason)}", state}
    end
  end

  defp via_tuple(user_id) do
    Langchaindemo.ProcessRegistry.via_tuple({__MODULE__, user_id})
  end
end
