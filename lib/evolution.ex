defmodule Genetics.Evolution do
  import Genetics.{Population, Dna}
  alias Genetics.{Population, Dna, Evolution}

  import IEx

  def phenotype(dna) do
    dna.genes |> to_string
  end

  def fitness(target, candidate) do
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

  def mutate(%Dna{fitness: fitness, genes: genes}, rate) do
    mutated_genes = do_mutation(rate, genes, [])
    %Dna{genes: mutated_genes} # we reset the fitness to zero
  end

  defp do_mutation(rate, [], new_genes) do
    new_genes |> Enum.reverse
  end

  defp do_mutation(rate, [head | tail], new_genes) do
    if :rand.uniform < rate do
      mutation = :rand.uniform(96) + 32
      do_mutation(rate, tail, [mutation | new_genes])
    else
      do_mutation(rate, tail, [head | new_genes])
    end
  end

  def seed do
    << i1 :: unsigned-integer-32, i2 :: unsigned-integer-32, i3 :: unsigned-integer-32>> = :crypto.strong_rand_bytes(12)
    :rand.seed(:exsplus, {i1, i2, i3})
  end
end
