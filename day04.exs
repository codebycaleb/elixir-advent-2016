defmodule Day04 do
  def filter(input) do
    input |> String.split() |> Enum.flat_map(&parse/1)
  end

  def transform(input) do
    Enum.map(input, &decrypt_entry/1)
  end

  defp parse(line) do
    [entry, number, checksum] = String.split(line, ~r(\d+), include_captures: true)
    entry = String.slice(entry, 0..-2)
    number = String.to_integer(number)
    checksum = String.slice(checksum, 1..5)
    generated_checksum = generate_checksum(entry)
    if generated_checksum == checksum do
      [{entry, number, checksum}]
    else
      []
    end
  end

  defp generate_checksum(entry) do
     entry
     |> String.to_charlist()
     |> Enum.filter(&(&1 != ?-))
     |> Enum.reduce(%{}, fn(x, acc) -> Map.update(acc, x, 1, &(&1 + 1)) end)
     |> Enum.sort(fn({letter1, count1}, {letter2, count2}) ->
       if count1 == count2 do
         letter1 < letter2
       else
         count1 > count2
       end
     end)
     |> Enum.map(fn({letter, _}) -> letter end)
     |> Enum.take(5)
     |> to_string()
  end

  defp decrypt_entry({text, shift, _}) do
    decrypted = text
    |> String.to_charlist()
    |> Enum.map(fn x -> if Enum.member?(?a..?z, x), do: ?a + rem(x - ?a + shift, 26), else: x end)
    |> to_string()
    {decrypted, shift}
  end
end

input = ["inputs", "day04.txt"] |> Path.join() |> File.read!() |> String.trim()
filtered = Day04.filter(input)
transformed = Day04.transform(filtered)
real_room_sum = filtered |> Enum.map(&(elem(&1, 1))) |> Enum.sum()
IO.puts("The sum of the sector IDs of the real rooms is #{real_room_sum}")
filters = ~w(north pole object)
IO.puts(~s(Filtered for "north", "pole", and "object":))
transformed |> Enum.filter(fn {x, _} -> Enum.all?(filters, &(String.contains?(x, &1))) end) |> IO.inspect
