defmodule Generator do
  @moduledoc """
  """

  use GenServer

  require Logger

  # IMPL

  def start_link(setup_file, environment_file, output_file) do
    GenServer.start_link(__MODULE__, {setup_file, environment_file, output_file}, name: __MODULE__)
  end

  def init({setup_file, environment_file, output_file}) do
    #[setup_file, environment_file, output_file] = IO.inspect(System.argv())
    %{
      "type" => "setup",
      "data" => setup
    } =
      setup_file
      |> File.read!()
      |> Poison.decode!()

    %{
      "type" => "environment",
      "data" => _environment
    } =
      environment_file
      |> File.read!()
      |> Poison.decode!()

    %{
      "type" => "output",
      "data" => _output
    } =
      output_file
      |> File.read!()
      |> Poison.decode!()

    :rand.seed(:exsplus, setup["seed"] |> List.to_tuple())

    grid_setup = setup["grid"]
    team_counts = setup["teams"] |> Enum.reduce(%{}, fn x, acc -> Map.put(acc, Enum.count(acc) + 1, Enum.count(x)) end)
    {_grid, _placement} = Grid.generate(String.to_existing_atom(grid_setup["type"]), grid_setup["dimensions"], grid_setup["obstacles"], team_counts)

  end
end
