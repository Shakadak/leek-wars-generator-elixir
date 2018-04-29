defmodule Effect.ItemTest do
  use ExUnit.Case

  test "Pistol effect" do
    assert Effect.Item.new(%{
    "type" => "damage",
    "min_roll" => 15,
    "max_roll" => 20,
    "duration" => "immediate",
    "target_type" => %{
      "enemies" => true,
      "allies" => true,
      "user" => true,
      "bulb" => true,
      "leek" => true,
    },
    "max_stack" => "infinity",
  }) == %Effect.Item{
      type: :damage,
      rolls: {15, 20},
      duration: :immediate,
      target_type: %{
      enemies: true,
      allies: true,
      user: true,
      bulb: true,
      leek: true,
    },
      max_stack: :infinity,
    }
  end
end
