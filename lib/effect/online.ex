defmodule Effect.Online do
  defstruct type: :damage,
            roll: 0,
            user: nil,
            duration: 1,
            critical?: true,
            item: nil,
            target: nil

  def new(%Effect.Item{
    type: type,
    rolls: {min, max},
  } = _description, %Entity{} = _user, roll, critical?, area_ratio) do
    crit_multiplier = if critical? do 1.4 else 1 end
    %__MODULE__{
      type: type,
      roll: (min + (max - min) * roll) * area_ratio * crit_multiplier,
    }
  end
end
