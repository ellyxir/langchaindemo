## TODO
* instead of !llm use @botname to call the llm
  * Message has mentions(), a list of mentions. 
  * get the bot's id: %Nostrum.Struct.User{id: bot_id} <- Nostrum.Cache.Me.get()
* make the bot responses replies
* response should be embed if it wants to share images and stuff... make a function for this
* summarize user context when it gets too large
* store summary in a db
* some way to share information? like share my info with corey?
* export into teams, slack, signal, telegram:w

## DONE
* add dialyzer
* truncate longer responses to 2k characters or send as two messages
* change system prompt to be more general
* need to keep user context
