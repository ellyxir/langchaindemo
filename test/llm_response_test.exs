defmodule LLMResponseTest do
  alias Langchaindemo.LLMResponse
  use ExUnit.Case

  test "from" do
    {:ok, llm_response} =
      %{}
      |> Map.put("content", "content here")
      |> Map.put("state", "chatting")
      |> LLMResponse.from()

    assert llm_response == %Langchaindemo.LLMResponse{
             content: "content here",
             state: "chatting"
           }
  end
end
