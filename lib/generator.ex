defmodule Generator do
  @moduledoc """
  """

  use GenServer

  require Logger

  # IMPL

  def start_link() do
    GenServer.start_link(__MODULE__, {}, name: __MODULE__)
  end

  def init({}) do
    [setup_file, environment_file, output_file] = IO.inspect(System.argv())
    %{
      "type" => "setup",
      "data" => _setup
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

  end
end
