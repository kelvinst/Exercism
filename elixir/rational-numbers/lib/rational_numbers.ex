defmodule RationalNumbers do
  @type rational :: {integer, integer}

  @doc """
  Add two rational numbers
  """
  @spec add(a :: rational, b :: rational) :: rational
  def add({a1, b1}, {a2, b2}), do: reduce({a1 * b2 + a2 * b1, b1 * b2})

  @doc """
  Subtract two rational numbers
  """
  @spec subtract(a :: rational, b :: rational) :: rational
  def subtract({a1, b1}, {a2, b2}), do: reduce({a1 * b2 - a2 * b1, b1 * b2})

  @doc """
  Multiply two rational numbers
  """
  @spec multiply(a :: rational, b :: rational) :: rational
  def multiply({a1, b1}, {a2, b2}), do: reduce({a1 * a2, b1 * b2})

  @doc """
  Divide two rational numbers
  """
  @spec divide_by(num :: rational, den :: rational) :: rational
  def divide_by({a1, b1}, {a2, b2}), do: reduce({a1 * b2, a2 * b1})

  @doc """
  Absolute value of a rational number
  """
  @spec abs(a :: rational) :: rational
  def abs({a, b}), do: reduce({Kernel.abs(a), Kernel.abs(b)})

  @doc """
  Exponentiation of a rational number by an integer
  """
  @spec pow_rational(a :: rational, n :: integer) :: rational
  def pow_rational(a, n) when n < 0, do: pow_rational(a, Kernel.abs(n))
  def pow_rational({a, b}, n), do: reduce({Integer.pow(a, n), Integer.pow(b, n)})

  @doc """
  Exponentiation of a real number by a rational number
  """
  @spec pow_real(x :: integer, n :: rational) :: float
  def pow_real(x, {a, b}), do: x |> :math.pow(a) |> :math.pow(1 / b)

  @doc """
  Reduce a rational number to its lowest terms
  """
  @spec reduce(a :: rational) :: rational
  def reduce({a, b}) do
    gcd = Integer.gcd(a, b)
    a = div(a, gcd)
    b = div(b, gcd)

    if b < 0 do
      {-a, -b}
    else
      {a, b}
    end
  end
end
