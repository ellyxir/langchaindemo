defmodule Langchaindemo do
  require Logger

  alias LangChain.Chains.LLMChain
  alias LangChain.ChatModels.ChatOpenAI
  alias LangChain.Message
  alias LangChain.MessageProcessors.JsonProcessor

  # all messages returned from LLM match the schema (see system prompt set in runtime.exs):
  #   {
  #   type": "object",
  #   "properties": {
  #     "content": {
  #       "type": "string",
  #       "description": "The text content of the message."
  #     },
  #     "state": {
  #       "enum": ["chatting", "playing"],
  #       "description": "The current state of the conversation, must be 'chatting' or 'playing'. set to 'playing' when the interaction is about playing with the user for example a d&d adventure or roleplaying. otherwise set to 'chatting'"
  #     }
  #   },
  #   "required": ["content", "state"],
  #   "additionalProperties": false
  # }
  # we expose the keys here for content and state
  def message_content_key(), do: "content"
  def message_state_key(), do: "state"

  def model(), do: Application.fetch_env!(:langchain, :model)

  def fallback_models() do
    Application.fetch_env!(:langchain, :fallback_models)
    |> Enum.map(fn elem -> chatopenai(elem) end)
  end

  def endpoint(), do: Application.fetch_env!(:langchain, :endpoint)
  def system_prompt(), do: Application.fetch_env!(:langchain, :system_prompt)

  def chatopenai(model) do
    ChatOpenAI.new!(%{
      endpoint: endpoint(),
      model: model,
      json_response: true
    })
  end

  def new_chain() do
    %{
      llm: chatopenai(model())
    }
    |> LLMChain.new!()
    |> LLMChain.add_message(Message.new_system!(system_prompt()))
    |> LLMChain.message_processors([JsonProcessor.new!(~r/(\{.*\})/s)])

    # ~r/```json(.*?)```/s)])
  end

  @spec run_user_prompt(LLMChain.t(), String.t()) ::
          {:ok, LLMChain.t()} | {:error, LLMChain.t(), LangChain.LangChainError.t()}
  def run_user_prompt(%LLMChain{} = chain, prompt) when is_binary(prompt) do
    chain
    |> LLMChain.add_message(Message.new_user!(prompt))
    |> LLMChain.run(with_fallbacks: fallback_models())
  end

  # TODO: dont return a map, return a real struct
  @spec get_last_message(LLMChain.t()) :: map()
  def get_last_message(%LLMChain{
        last_message: %LangChain.Message{
          content: _content_parts,
          processed_content: processed_content
        }
      }) do
    # we start with a list of LangChain.Message.ContentPart
    # we look for one that has type: :text

    # this is how we'd get the last message if we didnt use json_processor
    # default = "Could not find message content"

    # content_parts
    # |> Enum.find_value(default, fn %LangChain.Message.ContentPart{type: type, content: content} ->
    #   if type == :text, do: content
    # end)
    processed_content
  end
end
