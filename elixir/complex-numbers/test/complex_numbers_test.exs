defmodule ComplexNumbersTest do
  use ExUnit.Case

  def equal({a, b}, {c, d}) do
    assert_in_delta a, c, 1.0e-12
    assert_in_delta b, d, 1.0e-12
  end

  def equal(a, b) do
    assert_in_delta a, b, 1.0e-12
  end

  describe "Real part" do
    test "Real part of a purely real number" do
      z = {1, 0}
      output = ComplexNumbers.real(z)
      expected = 1

      equal(output, expected)
    end

    test "Real part of a purely imaginary number" do
      z = {0, 1}
      output = ComplexNumbers.real(z)
      expected = 0

      equal(output, expected)
    end

    test "Real part of a number with real and imaginary part" do
      z = {1, 2}
      output = ComplexNumbers.real(z)
      expected = 1

      equal(output, expected)
    end
  end

  describe "Imaginary part" do
    test "Imaginary part of a purely real number" do
      z = {1, 0}
      output = ComplexNumbers.imaginary(z)
      expected = 0

      equal(output, expected)
    end

    test "Imaginary part of a purely imaginary number" do
      z = {0, 1}
      output = ComplexNumbers.imaginary(z)
      expected = 1

      equal(output, expected)
    end

    test "Imaginary part of a number with real and imaginary part" do
      z = {1, 2}
      output = ComplexNumbers.imaginary(z)
      expected = 2

      equal(output, expected)
    end
  end

  test "Imaginary unit" do
    z1 = {0, 1}
    z2 = {0, 1}
    output = ComplexNumbers.mul(z1, z2)
    expected = {-1, 0}

    equal(output, expected)
  end

  describe "Addition" do
    test "Add purely real numbers" do
      z1 = {1, 0}
      z2 = {2, 0}
      output = ComplexNumbers.add(z1, z2)
      expected = {3, 0}

      equal(output, expected)
    end

    test "Add purely imaginary numbers" do
      z1 = {0, 1}
      z2 = {0, 2}
      output = ComplexNumbers.add(z1, z2)
      expected = {0, 3}

      equal(output, expected)
    end

    test "Add numbers with real and imaginary part" do
      z1 = {1, 2}
      z2 = {3, 4}
      output = ComplexNumbers.add(z1, z2)
      expected = {4, 6}

      equal(output, expected)
    end
  end

  describe "Subtraction" do
    test "Subtract purely real numbers" do
      z1 = {1, 0}
      z2 = {2, 0}
      output = ComplexNumbers.sub(z1, z2)
      expected = {-1, 0}

      equal(output, expected)
    end

    test "Subtract purely imaginary numbers" do
      z1 = {0, 1}
      z2 = {0, 2}
      output = ComplexNumbers.sub(z1, z2)
      expected = {0, -1}

      equal(output, expected)
    end

    test "Subtract numbers with real and imaginary part" do
      z1 = {1, 2}
      z2 = {3, 4}
      output = ComplexNumbers.sub(z1, z2)
      expected = {-2, -2}

      equal(output, expected)
    end
  end

  describe "Multiplication" do
    test "Multiply purely real numbers" do
      z1 = {1, 0}
      z2 = {2, 0}
      output = ComplexNumbers.mul(z1, z2)
      expected = {2, 0}

      equal(output, expected)
    end

    test "Multiply purely imaginary numbers" do
      z1 = {0, 1}
      z2 = {0, 2}
      output = ComplexNumbers.mul(z1, z2)
      expected = {-2, 0}

      equal(output, expected)
    end

    test "Multiply numbers with real and imaginary part" do
      z1 = {1, 2}
      z2 = {3, 4}
      output = ComplexNumbers.mul(z1, z2)
      expected = {-5, 10}

      equal(output, expected)
    end
  end

  describe "Division" do
    test "Divide purely real numbers" do
      z1 = {1, 0}
      z2 = {2, 0}
      output = ComplexNumbers.div(z1, z2)
      expected = {0.5, 0}

      equal(output, expected)
    end

    test "Divide purely imaginary numbers" do
      z1 = {0, 1}
      z2 = {0, 2}
      output = ComplexNumbers.div(z1, z2)
      expected = {0.5, 0}

      equal(output, expected)
    end

    test "Divide numbers with real and imaginary part" do
      z1 = {1, 2}
      z2 = {3, 4}
      output = ComplexNumbers.div(z1, z2)
      expected = {0.44, 0.08}

      equal(output, expected)
    end
  end

  describe "Absolute value" do
    test "Absolute value of a positive purely real number" do
      z = {5, 0}
      output = ComplexNumbers.abs(z)
      expected = 5

      equal(output, expected)
    end

    test "Absolute value of a negative purely real number" do
      z = {-5, 0}
      output = ComplexNumbers.abs(z)
      expected = 5

      equal(output, expected)
    end

    test "Absolute value of a purely imaginary number with positive imaginary part" do
      z = {0, 5}
      output = ComplexNumbers.abs(z)
      expected = 5

      equal(output, expected)
    end

    test "Absolute value of a purely imaginary number with negative imaginary part" do
      z = {0, -5}
      output = ComplexNumbers.abs(z)
      expected = 5

      equal(output, expected)
    end

    test "Absolute value of a number with real and imaginary part" do
      z = {3, 4}
      output = ComplexNumbers.abs(z)
      expected = 5

      equal(output, expected)
    end
  end

  describe "Complex conjugate" do
    test "Conjugate a purely real number" do
      z = {5, 0}
      output = ComplexNumbers.conjugate(z)
      expected = {5, 0}

      equal(output, expected)
    end

    test "Conjugate a purely imaginary number" do
      z = {0, 5}
      output = ComplexNumbers.conjugate(z)
      expected = {0, -5}

      equal(output, expected)
    end

    test "Conjugate a number with real and imaginary part" do
      z = {1, 1}
      output = ComplexNumbers.conjugate(z)
      expected = {1, -1}

      equal(output, expected)
    end
  end

  describe "Complex exponential function" do
    test "Euler's identity/formula" do
      z = {0, :math.pi()}
      output = ComplexNumbers.exp(z)
      expected = {-1, 0}

      equal(output, expected)
    end

    test "Exponential of 0" do
      z = {0, 0}
      output = ComplexNumbers.exp(z)
      expected = {1, 0}

      equal(output, expected)
    end

    test "Exponential of a purely real number" do
      z = {1, 0}
      output = ComplexNumbers.exp(z)
      expected = {:math.exp(1), 0}

      equal(output, expected)
    end

    test "Exponential of a number with real and imaginary part" do
      z = {:math.log(2), :math.pi()}
      output = ComplexNumbers.exp(z)
      expected = {-2, 0}

      equal(output, expected)
    end
  end
end
