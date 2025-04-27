defmodule Langchaindemo.Bot.Consumer do
  use Nostrum.Consumer
  require Logger

  alias Nostrum.Api.Message
  alias Langchaindemo.Util

  @discord_max_msg_length 1700

  def handle_event(
        {:MESSAGE_CREATE,
         %Nostrum.Struct.Message{
           content: llm_prompt,
           channel_id: channel_id,
           author: %Nostrum.Struct.User{id: user_id, bot: nil},
           mentions: mentions
         } = _msg, _ws_state}
      ) when not is_nil(mentions) and length(mentions) > 0 do
    Logger.debug("Consumer: user_id #{user_id}, prompt=#{llm_prompt}")

    with %Nostrum.Struct.User{id: bot_id} <- Nostrum.Cache.Me.get(),
         true <- Enum.any?(mentions, fn %Nostrum.Struct.User{id: cur_id} -> cur_id == bot_id end),
         # ensure we have a UserServer running for this user
         pid <- Langchaindemo.UserSupervisor.server_process(user_id),
         {:ok, %Langchaindemo.LLMResponse{content: response_content} = response} <- Langchaindemo.UserServer.run_prompt(user_id, llm_prompt) do
      response_content
      |> Util.split_len(@discord_max_msg_length)
      |> Enum.each(fn llm_msg when is_binary(llm_msg) ->
        {:ok, _msg} = Message.create(channel_id, llm_msg)
      end)

      Logger.debug(
        "user_id #{user_id}, user_server=#{inspect(pid)}, llm response=#{inspect(response)}"
      )

      :ok
    else
      {:error, :timeout} ->
        _ = Message.create(channel_id, "Error: LLM took long to respond")

      # {:ok, nil} ->
      #   # probably a json error
      #   Logger.error("consumer.handle_event: nil parsed_content")
      #   _ = Message.create(channel_id, "Error: no data, probably JSON parsing failure")
      #   {:error, "nil as message.parsed_content"}
        
      error ->
        Logger.error("consumer.handle_event: message_create: user_id=#{user_id}, error=#{inspect error}")
        _ = Message.create(channel_id, "Error: #{inspect error}")
        {:error, error}
    end
  end
end
