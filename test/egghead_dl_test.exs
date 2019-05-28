defmodule EggheadDlTest do
  use ExUnit.Case
  doctest EggheadDl

  test "greets the world" do
    assert EggheadDl.hello() == :world
  end
end
