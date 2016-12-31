defmodule ChapterThree do
  defp filtered_lines!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
  end

  def large_lines!(path) do
    filtered_lines!(path)
    |> Enum.filter(&(String.length(&1) > 80))
  end

  def line_lengths!(path) do
    filtered_lines!(path)
    |> Enum.map(&String.length/1)
  end

  def longest_line_length!(path) do
    filtered_lines!(path)
    |> Stream.map(&String.length/1)
    |> Enum.reduce(0, &max/2)
  end

  defp longer_line(lineA, lineB) do
    if (String.length(lineA) > String.length(lineB)) do
      lineA
    else
      lineB
    end
  end

  def longest_line!(path) do
    filtered_lines!(path)
    |> Enum.reduce("", &longer_line/2)
  end

  def words_per_line! (path) do
    File.stream!(path)
    |> Stream.map(&String.split/1)
    |> Enum.map(&length/1)
  end
end
