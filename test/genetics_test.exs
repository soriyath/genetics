defmodule GeneticsTest do
  use ExUnit.Case

  import Genetics.{Dna,Population}
  alias Genetics.{Dna,Population}

  test "a mutation with a 100% rate changes the dna" do
    original = %Dna{genes: 'Truth'}
    mutation = Population.mutate(original, 1)
    assert mutation.genes != 'Truth'
  end

  test "a mutation with a 0% rate does not change the dna" do
    original = %Dna{genes: 'Truth'}
    mutation = Population.mutate(original, 0)
    assert mutation.genes == 'Truth'
  end

  test "select should select statistically the fittest individual" do
    population = [
      %Dna{fitness: 0.999999999990, genes: 'should be selected'},
      %Dna{fitness: 0.000000000001, genes: 'should not be selected'},
      %Dna{fitness: 0.000000000001, genes: 'should not be selected'},
      %Dna{fitness: 0.000000000001, genes: 'should not be selected'},
      %Dna{fitness: 0.000000000001, genes: 'should not be selected'},
      %Dna{fitness: 0.000000000001, genes: 'should not be selected'},
      %Dna{fitness: 0.000000000001, genes: 'should not be selected'},
      %Dna{fitness: 0.000000000001, genes: 'should not be selected'},
      %Dna{fitness: 0.000000000001, genes: 'should not be selected'},
      %Dna{fitness: 0.000000000001, genes: 'should not be selected'},
      %Dna{fitness: 0.000000000001, genes: 'should not be selected'},
    ]

    the_one = Population.select population

    assert the_one.genes == 'should be selected'
  end

  test "generating the next epoch creates a new population" do
    old_population = [
      %Dna{fitness: 0.1, genes: 'asdfasdfasdfasdfasdfasdf'},
      %Dna{fitness: 0.1, genes: 'qwerqwerqwerqwerqwerqwer'},
      %Dna{fitness: 0.1, genes: 'yxcvyxcvyxcvyxcvyxcvyxcv'},
      %Dna{fitness: 0.1, genes: 'uipouopiuiopuipupoiupoui'},
      %Dna{fitness: 0.1, genes: 'nm,.nm,.n,mnm,.n,m.n.,n.'},
      %Dna{fitness: 0.1, genes: 'jkéjkéjkéljkléjkléjkljlé'},
      %Dna{fitness: 0.1, genes: '123412341234123412341234'},
      %Dna{fitness: 0.1, genes: '789078907897890789078907'},
      %Dna{fitness: 0.1, genes: 'cvbncvbnmvcbnmvnbmvnbmcm'},
      %Dna{fitness: 0.1, genes: 'ertzurtuzertzertzertzert'},
    ]
    new_population = Population.select_reproduce_and_mutate(old_population)

    assert old_population -- new_population != []
  end

  test "generating the next epoch creates a new population of the same length" do
    old_population = [
      %Dna{fitness: 0.1, genes: 'asdfasdfasdfasdfasdfasdf'},
      %Dna{fitness: 0.1, genes: 'qwerqwerqwerqwerqwerqwer'},
      %Dna{fitness: 0.1, genes: 'yxcvyxcvyxcvyxcvyxcvyxcv'},
      %Dna{fitness: 0.1, genes: 'uipouopiuiopuipupoiupoui'},
      %Dna{fitness: 0.1, genes: 'nm,.nm,.n,mnm,.n,m.n.,n.'},
      %Dna{fitness: 0.1, genes: 'jkéjkéjkéljkléjkléjkljlé'},
      %Dna{fitness: 0.1, genes: '123412341234123412341234'},
      %Dna{fitness: 0.1, genes: '789078907897890789078907'},
      %Dna{fitness: 0.1, genes: 'cvbncvbnmvcbnmvnbmvnbmcm'},
      %Dna{fitness: 0.1, genes: 'ertzurtuzertzertzertzert'},
    ]
    new_population = Population.select_reproduce_and_mutate(old_population)

    assert Enum.count(old_population) == Enum.count(new_population)
  end
end
