import Config

config :langchain, openai_key: System.fetch_env!("OPENROUTER_API_KEY")
