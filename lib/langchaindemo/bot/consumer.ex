defmodule Langchaindemo.Bot.Consumer do
  use Nostrum.Consumer
  require Logger

  alias Nostrum.Api.Message
  alias Langchaindemo.Util

  @discord_max_msg_length 1700

  # TODO: actually should be recusive when we split because it might be more than double the max size  
  def handle_event(
        {:MESSAGE_CREATE,
         %Nostrum.Struct.Message{
           content: "!llm " <> llm_prompt,
           channel_id: channel_id,
           author: %Nostrum.Struct.User{id: user_id, bot: nil}
         } = _msg, _ws_state}
      ) do
    Logger.debug("Consumer: userid #{user_id}, prompt=#{llm_prompt}")

    # ensure we have a UserServer running for this user
    _pid = Langchaindemo.UserSupervisor.server_process(user_id)

    response =
      Langchaindemo.UserServer.run_prompt(user_id, llm_prompt)
      |> Util.split_len(@discord_max_msg_length)
      |> Enum.each(fn llm_msg when is_binary(llm_msg) ->
        {:ok, _msg} = Message.create(channel_id, llm_msg)
      end)

    Logger.debug("userid #{user_id} llm response=#{response}")
  end
end
