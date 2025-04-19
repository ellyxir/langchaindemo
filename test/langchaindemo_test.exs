defmodule LangchaindemoTest do
  use ExUnit.Case
  doctest Langchaindemo

  test "greets the world" do
    assert Langchaindemo.hello() == :world
  end
end
