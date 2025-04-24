defmodule Langchaindemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Langchaindemo.Worker.start_link(arg)
      # {Langchaindemo.Worker, arg}
      Langchaindemo.Bot.Consumer,
      Langchaindemo.ProcessRegistry
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Langchaindemo.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
