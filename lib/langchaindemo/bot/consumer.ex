defmodule Langchaindemo.Bot.Consumer do
  use Nostrum.Consumer
  require Logger
  
  alias Nostrum.Api.Message

  @discord_max_msg_length 1000

  # TODO: actually should be recusive when we split because it might be more than double the max size  
  def handle_event(
        {:MESSAGE_CREATE,
         %Nostrum.Struct.Message{
           content: "!llm " <> llm_prompt,
           channel_id: channel_id,
           author: %Nostrum.Struct.User{id: user_id, bot: nil}
         } = _msg, _ws_state}
      ) do
    Logger.debug("userid #{user_id} asked question: #{llm_prompt}")
    response = Langchaindemo.doit(llm_prompt)
    |> String.split_at(@discord_max_msg_length)
    |> Tuple.to_list()
    |> Enum.each(fn 
      ""  -> :ok
      llm_msg when is_binary(llm_msg) -> 
        {:ok, _msg} = Message.create(channel_id, llm_msg)
        :ok
    end)
    Logger.debug("userid #{user_id} llm response=#{response}")
  end
end
