defmodule Grid do
  @moduledoc """
  Grid creation
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

  def generate_count(seed, grid, count) do
    :rand.seed(:exsplus, seed)
    grid
    |> Map.keys()
    |> Enum.take_random(count)
    |> Enum.map(&{&1, :obstacle})
    |> Enum.into(grid)
  end

  def generate_density({seed, {_width, _height}}, _density) do
    {seed, %{}}
  end

  def place_participants({seed, _grid}, _participants) do
    {seed, %{}}
  end
end
