defmodule Day03 do
  def execute(input, grouping_function) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk(9)
    |> grouping_function.()
    |> Enum.map(&evaluate/1)
    |> Enum.sum()
  end

  defp evaluate(chunk) do
    Enum.count(chunk, fn line ->
      sorted = line |> Enum.sort()
      ab = sorted |> Enum.take(2) |> Enum.sum()
      c = sorted |> Enum.drop(2) |> Enum.sum()
      ab > c
     end)
  end
end

input = ["inputs", "day03.txt"] |> Path.join() |> File.read!() |> String.trim()

grouping_function_1 = fn x -> Enum.map(x, &(Enum.chunk(&1, 3))) end
grouping_function_2 = fn x -> Enum.map(x,
fn(g) ->
  g
  |> Enum.with_index()
  |> Enum.group_by(&(rem(elem(&1, 1), 3)), &(elem(&1, 0)))
  |> Enum.map(&(elem(&1, 1)))
end) end
output_1 = Day03.execute(input, grouping_function_1)
output_2 = Day03.execute(input, grouping_function_2)

IO.puts("#{output_1} horizontal triangles are possible")
IO.puts("#{output_2} vertical triangles are possible")
