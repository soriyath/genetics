defmodule GeneticsTest do
  use ExUnit.Case
  doctest Genetics

  import Genetics.{Evolution,Dna,Population}
  alias Genetics.{Evolution,Dna,Population}

  test "greets the world" do
    assert Genetics.hello() == :world
  end

  test "a mutation with a 100% rate changes the dna" do
    original = %Dna{fitness: 0, genes: 'Truth'}
    mutation = Evolution.mutate(original, 1)
    assert mutation.genes != 'Truth'
  end

  test "a mutation with a 0% rate does not change the dna" do
    original = %Dna{fitness: 0, genes: 'Truth'}
    mutation = Evolution.mutate(original, 0)
    assert mutation.genes == 'Truth'
  end
end
