defmodule ItemTest do
  use ExUnit.Case

  test "Pistol" do
    assert Item.new(%{
      "initial_cooldown" => 0,
      "cooldown" => 0,
      "need_equipping" => true,
      "equip_cost" => 1,
      "use_cost" => 3,
      "min_range" => 1,
      "max_range" => 7,
      "is_inline" => false,
      "area_type" => "point",
      "need_los" => true,
      "is_revive" => false,
      "effects" => [],
  }) == %Item{
      current_cooldown: 0,
      cooldown_time: 0,
      need_equipping?: true,
      equip_cost: 1,
      use_cost: 3,
      reach: {1, 7},
      inline?: false,
      area_type: :point,
      need_los?: true,
      revive?: false,
      effects: [],
    }
  end
end
