defmodule GeneticAlgorithm do
  use Bmark
  import Genetics.{Evolution, Population, Dna}
  alias Genetics.{Evolution, Population, Dna}

  bmark :pop_500_rate_1pc, runs: 5 do
    Evolution.guess "My name is Alice."
  end

  bmark :pop_500_rate_5pc, runs: 5 do
    Evolution.guess "My name is Alice.", 500, 0.05
  end

  bmark :pop_1_000_rate_1pc, runs: 5 do, 1_000, 0.01
    Evolution.guess "My name is Alice."
  end

  bmark :pop_1_000_rate_5pc, runs: 5 do, 1_000, 0.05
    Evolution.guess "My name is Alice."
  end

  bmark :pop_5_000_rate_1pc, runs: 5 do, 5_000, 0.01
    Evolution.guess "My name is Alice."
  end

  bmark :pop_5_000_rate_5pc, runs: 5 do, 5_000, 0.05
    Evolution.guess "My name is Alice."
  end
end
