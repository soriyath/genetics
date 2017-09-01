defmodule Genetics.Population do
  import Genetics.Dna
  alias Genetics.Dna

  import IEx

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
end