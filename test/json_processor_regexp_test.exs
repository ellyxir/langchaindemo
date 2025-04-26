defmodule JsonProcessorRegexpTest do
  use ExUnit.Case
  
  test "text before json - llama4 maverick 4 free" do
    text = """
    To give you a good answer, I need more details. Are you thinking of a specific forest, like one from a game or a story, or just wondering about forests in general?
    {
      "content": "To give you a good answer, I need more details. Are you thinking of a specific forest, like one from a game or a story, or just wondering about forests in general?",
      "state": "chatting"
    }
    """

    [json_block] = Regex.run(~r/(\{.*\})/s, text, capture: :all_but_first)

    assert Jason.decode!(json_block) == %{
             "content" => "To give you a good answer, I need more details. Are you thinking of a specific forest, like one from a game or a story, or just wondering about forests in general?",
             "state" => "chatting"
           }
  end
end

