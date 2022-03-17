defmodule ComplexNumbers do
  @typedoc """
  In this module, complex numbers are represented as a tuple-pair containing the real and
  imaginary parts.
  For example, the real number `1` is `{1, 0}`, the imaginary number `i` is `{0, 1}` and
  the complex number `4+3i` is `{4, 3}'.
  """
  @type complex :: {float, float}

  @doc """
  Return the real part of a complex number
  """
  @spec real(a :: complex) :: float
  def real({a, _}), do: a

  @doc """
  Return the imaginary part of a complex number
  """
  @spec imaginary(a :: complex) :: float
  def imaginary({_, b}), do: b

  @doc """
  Multiply two complex numbers
  """
  @spec mul(a :: complex, b :: complex) :: complex
  def mul({a, b}, {c, d}), do: {a * c - b * d, b * c + a * d}

  @doc """
  Add two complex numbers
  """
  @spec add(a :: complex, b :: complex) :: complex
  def add({a, b}, {c, d}), do: {a + c, b + d}

  @doc """
  Subtract two complex numbers
  """
  @spec sub(a :: complex, b :: complex) :: complex
  def sub({a, b}, {c, d}), do: {a - c, b - d}

  @doc """
  Divide two complex numbers
  """
  @spec div(a :: complex, b :: complex) :: complex
  def div({a, b}, {c, d}) do
    {
      (a * c + b * d) / (:math.pow(c, 2) + :math.pow(d, 2)), 
      (b * c - a * d)/ (:math.pow(c, 2) + :math.pow(d, 2))
    }
  end

  @doc """
  Absolute value of a complex number
  """
  @spec abs(a :: complex) :: float
  def abs({a, b}), do: :math.sqrt(:math.pow(a, 2) + :math.pow(b, 2))

  @doc """
  Conjugate of a complex number
  """
  @spec conjugate(a :: complex) :: complex
  def conjugate({a, b}), do: {a, -b}

  @doc """
  Exponential of a complex number
  """
  @spec exp(a :: complex) :: complex
  def exp({a, b}), do: mul({:math.exp(a), 0.0}, {:math.cos(b), :math.sin(b)})
end
