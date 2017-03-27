defmodule Day01 do
  @directions [:n, :e, :s, :w]

  def execute(input) do
    start = {0, 0, :n}
    input
      |> String.split(", ")
      |> Enum.flat_map_reduce(start, &move/2)
  end

  def calc_distance({x, y, _}), do: calc_distance({x, y})
  def calc_distance({x, y}) do
    abs(x) + abs(y)
  end

  def calc_first_duplicate(locations) do
    Enum.reduce_while(locations, MapSet.new(), fn({x, y, _}, seen) ->
      original_size = MapSet.size(seen)
      updated = MapSet.put(seen, {x, y})
      if original_size != MapSet.size(updated), do: {:cont, updated}, else: {:halt, {x, y}}
    end)
  end

  defp move(orders, position) do
    {l_or_r, steps} = String.next_grapheme(orders)
    locations = position |> turn(l_or_r) |> step(String.to_integer(steps))
    {locations, List.last(locations)}
  end
  defp turn({x, y, d}, "R"), do: {x, y, Enum.fetch!(@directions, rem(Enum.find_index(@directions, fn(x) -> x == d end) + 1, Enum.count(@directions)))}
  defp turn({x, y, d}, "L"), do: {x, y, Enum.fetch!(@directions, rem(Enum.find_index(@directions, fn(x) -> x == d end) + Enum.count(@directions) - 1, Enum.count(@directions)))}
  defp step({x, y, :n}, steps), do: Enum.map((y + 1)..(y + steps), &{x, &1, :n})
  defp step({x, y, :e}, steps), do: Enum.map((x + 1)..(x + steps), &{&1, y, :e})
  defp step({x, y, :s}, steps), do: Enum.map((y - 1)..(y - steps), &{x, &1, :s})
  defp step({x, y, :w}, steps), do: Enum.map((x - 1)..(x - steps), &{&1, y, :w})
end


input = ["inputs", "day01.txt"] |> Path.join() |> File.read!() |> String.trim()

{locations, final_location} = Day01.execute(input)
total_distance = Day01.calc_distance(final_location)
first_duplicate_distance = locations |> Day01.calc_first_duplicate() |> Day01.calc_distance

IO.puts("Easter Bunny HQ is #{total_distance} blocks away")
IO.puts("The first location visited twice is #{first_duplicate_distance} blocks away")
