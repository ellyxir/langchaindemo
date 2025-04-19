import Config

config :langchain, 
  openai_key: System.fetch_env!("OPENROUTER_API_KEY"),
  endpoint: "https://openrouter.ai/api/v1/chat/completions",
  model: "meta-llama/llama-4-scout:free"
