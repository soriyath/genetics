defmodule GeneticsTest do
  use ExUnit.Case
  doctest Genetics

  import Genetics.{Shiva,Dna,Population}
  alias Genetics.{Shiva,Dna,Population}

  test "greets the world" do
    assert Genetics.hello() == :world
  end

  test "a mutation with a 100% changes the dna" do
    original = %Dna{fitness: 0, genes: 'Truth'}
    mutation = Shiva.mutate(original, 1)
    assert mutation.genes !== 'Truth'
  end

  test "a mutation with a 0% does not change the dna" do
    original = %Dna{fitness: 0, genes: 'Truth'}
    mutation = Shiva.mutate(original, 0)
    assert mutation.genes === 'Truth'
  end
end
