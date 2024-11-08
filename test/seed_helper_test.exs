defmodule SeedHelperTest do
  use ExUnit.Case
  doctest SeedHelper

  test "greets the world" do
    assert SeedHelper.hello() == :world
  end
end
