defmodule Fraction do
  defstruct a: nil, b: nil

  def new(numerator, denominator) do
    %Fraction{a: numerator, b: denominator}
  end

  def add(%Fraction{a: numA, b: demA}, %Fraction{a: numB, b: demB}) do
    %Fraction{
      a: (numA * demB + numB * demA),
      b: demA * demB
    }
  end

  def value(%Fraction{a: a, b: b}) do
    a / b
  end
end