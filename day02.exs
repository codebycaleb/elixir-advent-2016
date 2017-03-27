defmodule Day02 do
  @fn_mappings %{"U" => 0, "R" => 1, "D" => 2, "L" => 3}

  def execute(input, mappings) do
    String.split(input) |> Enum.map_reduce({5, mappings}, &move/2) |> elem(0) |> Enum.join()
  end

  defp move(instructions, start_and_mappings) do
    {start, mappings} = start_and_mappings
    last = String.codepoints(instructions) |> Enum.reduce(start, fn(instruction, current) ->
      elem(mappings, @fn_mappings[instruction]).(current)
    end)
    {last, {last, mappings}}
  end
end

input = ["inputs", "day02.txt"] |> Path.join() |> File.read!() |> String.trim()

i_up = fn(x) -> if x <= 3, do: x, else: x - 3 end
i_right = fn(x) -> if rem(x, 3) == 0, do: x, else: x + 1 end
i_down = fn(x) -> if x >= 7, do: x, else: x + 3 end
i_left = fn(x) -> if rem(x, 3) == 1, do: x, else: x - 1 end
up_map = %{"A" => 6, 6 => 2, "D" => "B", "B" => 7, 7 => 3, 3 => 1, "C" => 8, 8 => 4}
right_map = %{2 => 3, 3 => 4, 5 => 6, 6 => 7, 7 => 8, 8 => 9, "A" => "B", "B" => "C"}
down_map = %{2 => 6, 6 => "A", 1 => 3, 3 => 7, 7 => "B", "B" => "D", 4 => 8, 8 => "C"}
left_map = %{4 => 3, 3 => 2, 9 => 8, 8 => 7, 7 => 6, 6 => 5, "C" => "B", "B" => "A"}
up = &(Map.get(up_map, &1, &1))
right = &(Map.get(right_map, &1, &1))
down = &(Map.get(down_map, &1, &1))
left = &(Map.get(left_map, &1, &1))
incorrect_code = Day02.execute(input, {i_up, i_right, i_down, i_left})
correct_code = Day02.execute(input, {up, right, down, left})

IO.puts("The square bathroom code is #{incorrect_code}")
IO.puts("The diamond bathroom code is #{correct_code}")
