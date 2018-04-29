defmodule Entity do
  defstruct [
    type: :leek,
    id: nil,
    team: nil,
    level: 0,
    mp: 0,
    tp: 0,
    strength: 0,
    magic: 0,
    wisdom: 0,
    resistance: 0,
    science: 0,
    malice: 0,
    agility: 0,
    max_life: 0,
    life: 0,
    alive?: false,
    items: [],
  ]

  def new(%{}, _team, type \\ :leek) do
    %__MODULE__{
      type: type,
    }
  end

  def refresh_cooldowns(items) do
    items
    |> Enum.map(&Map.update(&1, :current_cooldown, 0, fn x -> max(0, x - 1) end))
  end
end
