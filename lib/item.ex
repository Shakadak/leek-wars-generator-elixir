defmodule Item do
  @enforce_keys [
    :current_cooldown,
    :cooldown_time,
    :need_equipping?,
    :equip_cost,
    :use_cost,
    :reach,
    :inline?,
    :area_type,
    :need_los?,
    :revive?,
    :effects
  ]
  defstruct current_cooldown: 0,
            cooldown_time: 0,
            need_equipping?: false,
            equip_cost: 0,
            use_cost: 1,
            reach: {0, 0},
            inline?: false,
            area_type: :point,
            need_los?: true,
            revive?: false,
            effects: []

  @area_types [:point, :laser, :circle_1, :disk_2, :disk_3]

  def new(%{
        "initial_cooldown" => initial_cooldown,
        "cooldown" => cooldown,
        "need_equipping" => need_equipping,
        "equip_cost" => equip_cost,
        "use_cost" => use_cost,
        "min_range" => min_range,
        "max_range" => max_range,
        "is_inline" => is_inline,
        "area_type" => area_type,
        "need_los" => need_los,
        "is_revive" => is_revive,
        "effects" => effects
      })
      when is_integer(initial_cooldown) and initial_cooldown >= 0 and is_integer(cooldown) and
             cooldown >= 0 and is_boolean(need_equipping) and is_integer(equip_cost) and
             equip_cost >= 0 and is_integer(use_cost) and use_cost > 0 and is_integer(min_range) and
             min_range >= 0 and is_integer(max_range) and max_range >= 0 and is_boolean(is_inline) and
             is_binary(area_type) and is_boolean(need_los) and is_boolean(is_revive) and
             is_list(effects) do
    _ = @area_types

    %__MODULE__{
      current_cooldown: initial_cooldown,
      cooldown_time: cooldown,
      need_equipping?: need_equipping,
      equip_cost: equip_cost,
      use_cost: use_cost,
      reach: {min_range, max_range},
      inline?: is_inline,
      area_type: String.to_existing_atom(area_type),
      need_los?: need_los,
      revive?: is_revive,
      effects: Enum.map(effects, &Effect.Item.new/1)
    }
  end
end
