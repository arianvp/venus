defmodule Venus.Codec do
@moduledoc """
Defines helper functions for working with the game protocol
"""

  @doc """
  """
  def order(<<b>>, order) do
    <<b>>
  end

  def order(a, :big) do
    a
  end

  def order(<<a,b>>, :little) do
    <<b,a>>
  end

  def order(<<a,b,c,d>>, :little) do
    <<d,c,a,b>>
  end

  def order(<<a,b,c,d>>, :middle) do
    <<b,a,d,c>>
  end

  def order(<<a,b,c,d>>, inversed_middle) do
    <<c,d,a,b>>
  end


  @doc """
  """
  def transform(<<b,rest::binary>>,trans) do
    case trans do
      :add -> <<b+128,rest>>
      :neg -> <<-b,rest>>
      :sub -> <<128,rest>>
    end
  end

  @doc """
  """
  def to_int(truthy) do
    if truthy do
      1
    else
      0
    end
  end

  @doc """
  Pads bitstrings to a binary by padding it to be byte-aligned
        iex> to_binary(<<3>>)
        <<3>>
        iex> to_binary(<<3::size(7)>>)
        <<3>>
  """
  @spec to_binary(bitstring) :: binary
  def to_binary(bitstring) do
  end

end
