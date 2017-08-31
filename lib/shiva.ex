defmodule Genetics.Shiva do
  import Genetics.{Population, Dna}
  alias Genetics.{Population, Dna, Shiva}

  import IEx

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

  def do_mutation(rate, [], new_genes) do
    new_genes |> Enum.reverse
  end

  def do_mutation(rate, [head | tail], new_genes) do
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
