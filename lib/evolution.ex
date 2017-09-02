defmodule Genetics.Evolution do
  import Genetics.{Population, Dna}
  alias Genetics.{Population, Dna, Evolution}

  import IEx

  # TODO add a predator ?

  def guess(enigma \\ 'To be or not to be, that is the question')

  def guess(enigma) when enigma |> is_bitstring do
    enigma |> String.to_charlist |> guess
  end

  def guess(enigma) when enigma |> is_list do
    # 0. configuration, seed CSPRNG (erlang) and set the target DNA
    seed
    target = %Dna{genes: enigma}
    pop_size = 1_000
    max_fitness = :math.pow(100,4)

    # 1. generate a random population of N elements with random genetic material
    p0 = Population.setup(target, pop_size)

    # 2. we loop until we find a satisfying fitness
    p1 = shift_epoch(target, max_fitness, 0, p0)

    42
  end

  def guess(enigma) do
    {:error, reason: "Please enter a string value"}
  end

  defp shift_epoch(target, max_fitness, best_fitness, population)

  defp shift_epoch(target, max_fitness, best_fitness,population) when best_fitness >= max_fitness do
    population
  end

  defp shift_epoch(target, max_fitness, best_fitness, population) when population |> is_list do
    # 2.1 calculate fitness for N elements, try and make fitness exponential
    p1 = Population.fitness(target, population) # TODO move this outside the loop

    # 2.2 selection, reproduction and mutation
    p2 = Population.select_reproduce_and_mutate(p1)

    p3 = Population.fitness(target, p2)
    new_best_fitness = Population.get_max_fitness(p3)

    # start back at 2.1 with p3
    shift_epoch(target, max_fitness, new_best_fitness, p3)
  end

  defp shift_epoch(target, max_fitness, best_fitness, population) do
    {:error, reason: "Population is not a list"}
  end

  defp seed do
    << i1 :: unsigned-integer-32, i2 :: unsigned-integer-32, i3 :: unsigned-integer-32>> = :crypto.strong_rand_bytes(12)
    :rand.seed(:exsplus, {i1, i2, i3})
  end
end
