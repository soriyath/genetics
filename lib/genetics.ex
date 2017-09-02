defmodule Genetics do
  import Genetics.{Population, Dna}
  alias Genetics.{Population, Dna}

  @doc """
  Guesses a target string using a population of randomly generated strings.

  ## Parameters

    - enigma: string or charlist representing the targetted string to guess, defaults to the Shakespeare sentence (To be or not...) ;
    - population_size: integer representing the size of the population used by the algorithm, defaults to 500 ;
    - mutation_rate: float representing the probability of a mutation occuring after reproduction (0 <= n <= 1), defaults to 1%.

  ## Examples

      iex> Genetics.guess("Answer to the Ultimate Question of Life, the Universe, and Everything")
      %Genetics.Dna{fitness: 1.0e8, genes: 'Answer to the Ultimate Question of Life, the Universe, and Everything'}

  """
  def guess(enigma \\ 'To be or not to be, that is the question', population_size \\ 500, mutation_rate \\ 0.01)

  def guess(enigma, population_size, mutation_rate) when enigma |> is_bitstring do
    enigma |> String.to_charlist |> guess(population_size, mutation_rate)
  end

  def guess(enigma, population_size, mutation_rate) when enigma |> is_list do
    # 0. configuration, seed CSPRNG (erlang) and set the target DNA
    seed
    target = %Dna{genes: enigma}
    max_fitness = :math.pow(100,4)

    IO.puts "Configuration:\n==============\n\ntarget: #{enigma}\npopulation size: #{population_size}\nmutation rate: #{mutation_rate}\n\n"

    # 1. generate a random population of N elements with random genetic material
    p0 = Population.setup(target, population_size)

    # 2. we loop until we find a satisfying fitness
    p1 = shift_epoch(target, max_fitness, 1, p0, mutation_rate)

    Population.get_best_fit(p1)
  end

  def guess(enigma, population_size, mutation_rate) do
    {:error, reason: "Please enter a string value"}
  end

  defp shift_epoch(target, max_fitness, best_fitness, population, mutation_rate, old_fitness \\ 1, epoch \\ 0)

  defp shift_epoch(target, max_fitness, best_fitness, population, mutation_rate, old_fitness, epoch) when best_fitness >= max_fitness do
    population
  end

  defp shift_epoch(target, max_fitness, best_fitness, population, mutation_rate, old_fitness, epoch) when population |> is_list do
    # 2.1 calculate fitness for N elements, try and make fitness exponential
    p1 = Population.fitness(target, population) # TODO move this outside the loop

    # 2.2 selection, reproduction and mutation
    p2 = Population.select_reproduce_and_mutate(p1, mutation_rate)

    p3 = Population.fitness(target, p2)
    best_fit = Population.get_best_fit(p3)
    IO.puts "epoch: #{epoch}, best fitness: #{best_fit.fitness}, with: #{best_fit.genes}, progression: #{best_fit.fitness / old_fitness}"

    # start back at 2.1 with p3
    shift_epoch(target, max_fitness, best_fit.fitness, p3, mutation_rate, best_fitness, epoch + 1)
  end

  defp shift_epoch(target, max_fitness, best_fitness, population, mutation_rate, old_fitness, epoch) do
    {:error, reason: "Population is not a list"}
  end

  defp seed do
    << i1 :: unsigned-integer-32, i2 :: unsigned-integer-32, i3 :: unsigned-integer-32>> = :crypto.strong_rand_bytes(12)
    :rand.seed(:exsplus, {i1, i2, i3})
  end
end
