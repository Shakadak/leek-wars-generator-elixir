defmodule LeekWarsGenerator do
  @moduledoc """
  Documentation for LeekWarsGenerator.
  """

  def start(_, _) do
    children = [
      Plug.Adapters.Cowboy.child_spec(scheme: :http, plug: LeekWarsGenerator.Api.Router, options: [port: 4001]),
    ]

    opts = [strategy: :one_for_one, name: LeekWarsGenerator.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
