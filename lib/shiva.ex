defmodule Genetics.Shiva do
  import Genetics.{Population, Dna}
  alias Genetics.{Population, Dna, Shiva}

  def crossover() do
    IO.puts "Implement this!"
  end

  def mutate(%Dna{fitness: fitness, genes: genes}, rate) do
    mutated_genes = do_mutation(rate, genes, [])
    %Dna{fitness: fitness, genes: mutated_genes}
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
end
