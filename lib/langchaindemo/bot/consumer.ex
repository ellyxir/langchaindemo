defmodule Langchaindemo.Bot.Consumer do
  use Nostrum.Consumer
  require Logger
  
  alias Nostrum.Api.Message

  def handle_event(
        {:MESSAGE_CREATE,
         %Nostrum.Struct.Message{
           content: "!llm " <> llm_prompt,
           author: %Nostrum.Struct.User{id: user_id, bot: nil}
         } = msg, _ws_state}
      ) do
    Logger.debug("userid #{user_id} asked question: #{llm_prompt}")
    response = Langchaindemo.doit(llm_prompt)
    Logger.debug("userid #{user_id} llm response=#{response}")
    {:ok, _msg} = Message.create(msg.channel_id, response)
  end
end
