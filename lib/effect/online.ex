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
