defmodule Langchaindemo do
  require Logger

  alias LangChain.Chains.LLMChain
  alias LangChain.ChatModels.ChatOpenAI
  alias LangChain.Message

  def model(), do: Application.fetch_env!(:langchain, :model)

  def fallback_models() do
    Application.fetch_env!(:langchain, :fallback_models)
    |> Enum.map(fn elem ->
      ChatOpenAI.new!(%{
        endpoint: endpoint(),
        model: elem
      })
    end)
  end

  def endpoint(), do: Application.fetch_env!(:langchain, :endpoint)
  def system_prompt(), do: Application.fetch_env!(:langchain, :system_prompt)

  def new_chain() do
    %{
      llm:
        ChatOpenAI.new!(%{
          endpoint: endpoint(),
          model: model()
        })
    }
    |> LLMChain.new!()
    |> LLMChain.add_message(Message.new_system!(system_prompt()))
  end

  @spec run_user_prompt(LLMChain.t(), String.t()) ::
          {:ok, LLMChain.t()} | {:error, LLMChain.t(), LangChain.LangChainError.t()}
  def run_user_prompt(%LLMChain{} = chain, prompt) when is_binary(prompt) do
    chain
    |> LLMChain.add_message(Message.new_user!(prompt))
    |> LLMChain.run(with_fallbacks: fallback_models())
  end

  @spec get_last_message(LLMChain.t()) :: String.t()
  def get_last_message(%LLMChain{last_message: %LangChain.Message{content: content_parts}}) do
    # we start with a list of LangChain.Message.ContentPart
    # we look for one that has type: :text
    default = "Could not find message content"

    content_parts
    |> Enum.find_value(default, fn %LangChain.Message.ContentPart{type: type, content: content} ->
      if type == :text, do: content
    end)
  end
end
