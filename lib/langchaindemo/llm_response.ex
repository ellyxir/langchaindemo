defmodule Langchaindemo.LLMResponse do
  @moduledoc """
    struct for a response from the LLM
  """

  defstruct [:content, :state]

  @type t() :: %__MODULE__{
          content: String.t(),
          state: :playing | :chatting
        }

  @spec from(map()) :: {:ok, t()} | {:error, any()}
  def from(json_map) when is_map(json_map) do
    {:ok,
     %__MODULE__{
       content: Map.get(json_map, "content"),
       state: Map.get(json_map, "state")
     }}
  end
end
