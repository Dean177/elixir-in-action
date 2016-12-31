defmodule FractionTest do
  use ExUnit.Case

  doctest Fraction

  test "value" do
    assert Fraction.new(1, 2) |> Fraction.value == 0.5
  end

  test "add" do
    half = Fraction.new(1, 2)
    quarter = Fraction.new(1, 4)

    assert Fraction.add(half, quarter) |> Fraction.value == 0.75
  end
  
end