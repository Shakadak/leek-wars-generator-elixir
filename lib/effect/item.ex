defmodule Effect.Item do
  defstruct [
    type: :damage,
    rolls: {0, 0},
    duration: 0,
    target_type: %{
      enemies: true,
      allies: true,
      user: true,
      bulb: true,
      leek: true,
    },
    max_stack: :infinity,
  ]

  @effect_types [
    :damage,
	:heal,
	:buff_strength,
	:buff_agility,
	:relative_shield,
	:absolute_shield,
	:buff_mp,
	:buff_tp,
	:debuff,
	:teleport,
	:permutation,
	:vitality,
	:poison,
	:summon,
	:resurrect,
	:kill,
	:shackle_mp,
	:shackle_tp,
	:shackle_strength,
	:damage_return,
	:buff_resistance,
	:buff_wisdom,
	:antidote,
	:shackle_magic,
	:aftereffect,
    :vulnerability,
  ]

  def new(%{
    "type" => type,
    "min_roll" => min_roll,
    "max_roll" => max_roll,
    "duration" => duration,
    "target_type" => target_type,
    "max_stack" => max_stack,
  })
  when is_binary(type)
    and is_integer(min_roll)
    and is_integer(max_roll)
    and (duration == "immediate" or is_integer(duration) and duration >= 0)
    and is_map(target_type)
    and (is_integer(max_stack) or max_stack == "infinity")
  do
    _ = @effect_types
    %__MODULE__{
      type: String.to_existing_atom(type),
      rolls: {min_roll, max_roll},
      duration: if duration == "immediate" do :immediate else duration end,
      target_type: target_type(target_type),
      max_stack: if max_stack == "infinity" do :infinity else max_stack end,
    }
  end

  def target_type(%{
    "enemies" => enemies,
    "allies" => allies,
    "user" => user,
    "bulb" => bulb,
    "leek" => leek,
  })
  when is_boolean(enemies)
    and is_boolean(allies)
    and is_boolean(user)
    and is_boolean(bulb)
    and is_boolean(leek)
  do
    %{
      enemies: enemies,
      allies: allies,
      user: user,
      bulb: bulb,
      leek: leek,
    }
  end
end
