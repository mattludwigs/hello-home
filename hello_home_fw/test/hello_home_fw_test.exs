defmodule HelloHomeFwTest do
  use ExUnit.Case
  doctest HelloHomeFw

  test "greets the world" do
    assert HelloHomeFw.hello() == :world
  end
end
