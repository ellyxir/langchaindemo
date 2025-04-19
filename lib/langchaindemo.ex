defmodule Langchaindemo do
  alias LangChain.Chains.LLMChain
  alias LangChain.ChatModels.ChatOpenAI
  alias LangChain.Message

  def doit do
    {:ok, updated_chain} =
      %{
        llm:
          ChatOpenAI.new!(%{
            endpoint: "https://openrouter.ai/api/v1/chat/completions",
            model: "meta-llama/llama-4-scout:free"
          })
      }
      |> LLMChain.new!()
      |> LLMChain.add_message(Message.new_user!("Testing, testing!"))
      |> LLMChain.run()

    updated_chain.last_message.content
  end
end
