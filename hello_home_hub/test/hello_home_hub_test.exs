defmodule HelloHomeHubTest do
  use ExUnit.Case
  doctest HelloHomeHub

  test "greets the world" do
    assert HelloHomeHub.hello() == :world
  end
end
