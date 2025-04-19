import Config

config :langchain, 
  openai_key: System.fetch_env!("OPENROUTER_API_KEY"),
  endpoint: "https://openrouter.ai/api/v1/chat/completions",
  model: "meta-llama/llama-4-scout:free",
  system_prompt: "You are an experienced gamemaster for fantasy TTRPGs"

config :nostrum,
  token: System.fetch_env!("LLM_BOT_TOKEN"),
  gateway_intents: :all
