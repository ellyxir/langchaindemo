defmodule Langchaindemo.UserSupervisor do
  use DynamicSupervisor
  require Logger

  def start_link(_) do
    Logger.debug("starting UserSupervisor")

    DynamicSupervisor.start_link(
      name: __MODULE__,
      strategy: :one_for_one
    )
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @spec server_process(non_neg_integer()) :: pid()
  def server_process(user_id) when is_integer(user_id) do
    case start_child(user_id) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  @spec start_child(non_neg_integer()) :: DynamicSupervisor.on_start_child()
  defp start_child(user_id) when is_integer(user_id) do
    DynamicSupervisor.start_child(
      __MODULE__,
      {Langchaindemo.UserServer, user_id}
    )
  end
end
