defmodule Langchaindemo do
  alias LangChain.Chains.LLMChain
  alias LangChain.ChatModels.ChatOpenAI
  alias LangChain.Message

  def model(), do: Application.fetch_env!(:langchain, :model)
  def endpoint(), do: Application.fetch_env!(:langchain, :endpoint)
  def system_prompt(), do: Application.fetch_env!(:langchain, :system_prompt)

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
