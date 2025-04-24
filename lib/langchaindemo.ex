defmodule Langchaindemo do
  alias LangChain.Chains.LLMChain
  alias LangChain.ChatModels.ChatOpenAI
  alias LangChain.Message

  def model(), do: Application.fetch_env!(:langchain, :model)
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
    |> LLMChain.run()
  end

  @spec get_last_message(LLMChain.t()) :: String.t()
  def get_last_message(%LLMChain{} = chain) do
    chain.last_message.content
  end

  def doit(llm_prompt) when is_binary(llm_prompt) do
    {:ok, updated_chain} =
      %{
        llm:
          ChatOpenAI.new!(%{
            endpoint: endpoint(),
            model: model()
          })
      }
      |> LLMChain.new!()
      |> LLMChain.add_messages([
        Message.new_system!(system_prompt()),
        Message.new_user!(llm_prompt)
      ])
      |> LLMChain.run()

    updated_chain.last_message.content
  end
end
