defmodule TgAppExTest do
  use ExUnit.Case
  doctest TgAppEx

  test "greets the world" do
    assert TgAppEx.hello() == :world
  end
end
