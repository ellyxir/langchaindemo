defmodule UtilTest do
  use ExUnit.Case

  alias Langchaindemo.Util

  describe "split_len/2" do
    test "returns empty list when input string is empty" do
      assert Util.split_len("", 5) == []
    end

    test "returns list with one element when string is shorter than len" do
      assert Util.split_len("abc", 5) == ["abc"]
    end

    test "returns list with one element when string is exactly len" do
      assert Util.split_len("abcde", 5) == ["abcde"]
    end

    test "splits string into equal chunks" do
      assert Util.split_len("abcdefghij", 2) == ["ab", "cd", "ef", "gh", "ij"]
    end

    test "last chunk is shorter when string length is not divisible by len" do
      assert Util.split_len("abcdefghijk", 4) == ["abcd", "efgh", "ijk"]
    end

    test "handles single character chunks" do
      assert Util.split_len("abc", 1) == ["a", "b", "c"]
    end

    test "raises if len is zero or negative" do
      assert_raise FunctionClauseError, fn -> Util.split_len("abc", 0) end
      assert_raise FunctionClauseError, fn -> Util.split_len("abc", -1) end
    end
  end
end
