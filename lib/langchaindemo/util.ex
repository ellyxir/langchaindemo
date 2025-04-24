defmodule Langchaindemo.Util do
  @doc """
  splits a string into a list of strings, each one of len length, last one length <= len
  """
  @spec split_len(binary(), integer()) :: [binary()]
  def split_len(s, len) when is_binary(s) and is_integer(len) and len > 0 do
    l = String.length(s)
    cond do
      l == 0 -> []
      l <= len -> [s]
      true -> 
        {head, tail} = String.split_at(s, len)
        [head | split_len(tail, len)]
    end
  end
end

