defmodule LeekWarsFightGenerator.MixProject do
  use Mix.Project

  def project do
    [
      app: :leek_wars_generator,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_options: [warnings_as_errors: true]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [
        :cowboy,
        :plug,
        :poison,
      ],
      extra_applications: [:logger],
      mod: {LeekWarsGenerator, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 2.5"},
      {:plug, "~> 1.6"},
      {:poison, "~> 4.0"}
    ]
  end
end
