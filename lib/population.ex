defmodule Genetics.Population do
  import Genetics.Dna
  alias Genetics.Dna

  def setup(target, size \\ 1_000, population \\ [])

  def setup(_, 0, population) do
    population
  end

  def setup(target, size, population) do
    genome_length = Enum.count target.genes
    individual = get_individual(genome_length)
    new_population = [individual | population]
    setup(target, size - 1, new_population)
  end

  defp get_individual(genome_length) do
    dna = get_dna(genome_length, %Dna{})
  end

  defp get_dna(0, dna) do
    dna
  end

  defp get_dna(length, %Dna{genes: genes}) do
    gene = :rand.uniform(96) + 32
    new_genes = [gene | genes] # reverse order eventually, but we don't care because it's random anyways
    get_dna(length - 1, %Dna{genes: new_genes})
  end

  def get_best_fit(population, initial \\ 0) do
    Enum.reduce(population, initial, fn(individual, best) ->
      best = 
        case individual.fitness > best do
          true -> individual
          false -> best
        end
    end)
  end

  def phenotype(dna) do
    dna.genes |> to_string
  end

  def fitness(target, population, newPopulation \\ [])

  def fitness(target, [], newPopulation) do
    Enum.reverse newPopulation
  end

  def fitness(target, [candidate | population_tail], newPopulation) do
    individual = individual_fitness(target, candidate)
    fitness(target, population_tail, [individual | newPopulation])
  end

  defp individual_fitness(target, candidate) do
    candidate_fitness = check_fitness(target.genes, candidate.genes, candidate.fitness)
    
    # normalize and make it exponentional
    normalized_fitness = candidate_fitness / Enum.count(target.genes) * 100 # we need to work with natural numbers
    exponentional_fitness = :math.pow(normalized_fitness, 4)

    %Dna{fitness: exponentional_fitness, genes: candidate.genes}
  end

  defp check_fitness([], [], fitness) do
    fitness
  end

  defp check_fitness([t_char | t_tail], [c_char | c_tail], fitness) do
    new_fitness = 
      case t_char == c_char do
        true -> fitness + 1
        false -> fitness
      end
    check_fitness(t_tail, c_tail, new_fitness)
  end

  # parentA and parentB are dna structs
  def crossover(parentA, parentB) do
    genome_length = Enum.count parentA.genes
    midpoint = :rand.uniform genome_length
    new_genes = Enum.slice(parentA.genes,0..midpoint-1) ++ Enum.slice(parentB.genes,midpoint..genome_length)
    %Dna{genes: new_genes}
  end

  def mutate(%Dna{fitness: fitness, genes: genes}, rate \\ 0.01) do
    mutant_genes = do_mutation(rate, genes, [])
    %Dna{genes: mutant_genes} # we reset the fitness to zero
  end

  defp do_mutation(rate, [], new_genes) do
    Enum.reverse new_genes
  end

  defp do_mutation(rate, [head | tail], new_genes) do
    if :rand.uniform < rate do
      mutation = :rand.uniform(95) + 31
      do_mutation(rate, tail, [mutation | new_genes])
    else
      do_mutation(rate, tail, [head | new_genes])
    end
  end

  def select_reproduce_and_mutate(population, mutation_rate, new_population \\ [], diff \\ nil)

  def select_reproduce_and_mutate(population, mutation_rate, new_population, 0) do
    Enum.reverse new_population
  end

  def select_reproduce_and_mutate(population, mutation_rate, new_population, diff) when population |> is_list do
    total_fitness =
      Enum.reduce(population, 0, fn(individual, sum) -> 
        sum = sum + individual.fitness
      end)
    weighted_population =
      Enum.map(population, fn(individual) -> 
        %Dna{fitness: individual.fitness / total_fitness, genes: individual.genes}
      end)

    parentA = select(weighted_population)
    parentB = select(weighted_population)

    child = crossover(parentA, parentB) |> mutate(mutation_rate)

    next_generation = [child | new_population]
    missing_individuals = Enum.count(population) - Enum.count(next_generation)

    select_reproduce_and_mutate(population, mutation_rate, next_generation, missing_individuals) 
  end

  def select_reproduce_and_mutate(population, mutation_rate, new_population, diff) do
    {:error, reason: "Population is not a list."}
  end

  def select(population, probability \\ :rand.uniform)

  def select([], probability) do
    nil
  end

  def select([individual | population_tail], probability) do
    case probability < individual.fitness do
      true -> individual
      false -> select population_tail, probability - individual.fitness
    end
  end
end