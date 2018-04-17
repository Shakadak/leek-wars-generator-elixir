defmodule Grid do
  @moduledoc """

  Grid creation


  :rand.seed(:exsplus, seed)
  """

  def disk(radius) do
    mkPair = fn x -> fn y -> {x, y} end end
    xs = -radius..radius
    ys = xs

    xs
    |> Enum.map(mkPair)
    |> Enum.flat_map(&Enum.map(ys, &1))
    |> Enum.filter(fn {x, y} -> (abs(x) + abs (y)) <= radius end)
  end

  def generate_count(grid, count) do
    grid
    |> Map.keys()
    |> Enum.take_random(count)
    |> Enum.map(&{&1, :obstacle})
    |> Enum.into(grid)
  end

  def generate_density(grid, _density) do
    grid
  end

  def place_participants(_grid, _participants) do
    %{}
  end
end
