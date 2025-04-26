defmodule Langchaindemo.MixProject do
  use Mix.Project

  def project do
    [
      app: :langchaindemo,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Langchaindemo.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:langchain, "~> 0.3.0"},
      # {:langchain, path: "../langchain"},
      {:langchain, github: "ellyxir/langchain", branch: "custom_langchain"},
      {:kino, "~> 0.12.0"},
      {:nostrum, "~> 0.10"},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end
end
