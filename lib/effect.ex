defmodule Effect.Item do
  defstruct [
    type: :damage,
    rolls: {0, 0},
    duration: 0,
    target_type: {
      true, # enemies:
      true, # allies:
      true, # user:
      true, # bulb:
      true, # leek:
    },
    max_stack: :infinity,
  ]
end

defmodule Effect.Online do
  defstruct [
    type: :damage,
    roll: 0,
    user: nil,
    duration: 1,
    critical?: true,
    item: nil,
    target: nil,
  ]
end
