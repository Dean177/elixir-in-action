defmodule ChapterThreeTest do
  use ExUnit.Case

  doctest ChapterThree

  # TODO how do I get a relative path?
  @test_file "./test/chapter_3/chapter_3_data"

  test "large_lines" do
    assert ChapterThree.large_lines!(@test_file) == []
  end

  test "line_lengths" do
    assert ChapterThree.line_lengths!(@test_file) == [5, 7, 8, 3, 3]
  end

  test "longest_line_length!" do
    assert ChapterThree.longest_line_length!(@test_file) == 8
  end

  test "longest_line!" do
    assert ChapterThree.longest_line!(@test_file) == "mnopqrst"
  end

  test "words_per_line!" do
    assert ChapterThree.words_per_line!(@test_file) == [1, 1, 1, 1, 1]
  end
end
