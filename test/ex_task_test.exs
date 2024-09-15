defmodule ExTaskTest do
  use ExUnit.Case
  doctest ExTask

  test "greets the world" do
    assert ExTask.hello() == :world
  end
end
