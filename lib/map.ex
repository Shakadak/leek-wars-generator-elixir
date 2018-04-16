defmodule Grid do
  @moduledoc """
  Grid creation
  """

  def emptyGrid(width, height) do
    %{}
  end

  def generateCount({seed, grid}, count) do
    {seed, %{}}
  end

  def generateDensity({seed, {width, height}}, density) do
    {seed, %{}}
  end

  def placeParticipants({seed, grid}, participants) do
    {seed, %{}}
  end
end
