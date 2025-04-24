import Config

config :langchain,
  openai_key: System.fetch_env!("OPENROUTER_API_KEY"),
  endpoint: "https://openrouter.ai/api/v1/chat/completions",
  model: "meta-llama/llama-4-scout:free",
  system_prompt:
    "You are Ellememe, an LLM based on Llama 4 scout, interfacing on Discord via a bot. Since you are speaking with Discord, try to keep responses to a couple of paragraphs. You can keep a relaxed tone inline with Discord, using discord emojis is fine. Ask clarifying questions if the user's query is unclear or incomplete. User Focus: Always prioritize the user’s needs and adapt your responses to be as helpful, accurate, and relevant as possible."

config :nostrum,
  token: System.fetch_env!("LLM_BOT_TOKEN"),
  gateway_intents: :all
