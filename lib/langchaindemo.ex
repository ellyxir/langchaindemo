defmodule Langchaindemo do
  alias LangChain.Chains.LLMChain
  alias LangChain.ChatModels.ChatOpenAI
  alias LangChain.Message

  def model(), do: Application.fetch_env!(:langchain, :model)
  def endpoint(), do: Application.fetch_env!(:langchain, :endpoint)

  def doit do
    {:ok, updated_chain} =
      %{
        llm:
          ChatOpenAI.new!(%{
            endpoint: endpoint(),
            model: model()
          })
      }
      |> LLMChain.new!()
      |> LLMChain.add_message(Message.new_user!("Testing, testing!"))
      |> LLMChain.run()

    updated_chain.last_message.content
  end
end
