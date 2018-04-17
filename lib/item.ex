defmodule Item do
  defstruct [
    current_cooldown: 0,
    cooldown_time: 0,
    need_equipping?: false,
    equip_cost: 0,
    use_cost: 1,
    reach: {0, 0},
    inline?: false,
    area_type: :area_point,
    need_los?: true,
    revive?: false,
    effects: [],
  ]
end
