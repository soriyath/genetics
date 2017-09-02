# Genetics

This is a *loose* Elixir port of the genetic algorithm shown by Daniel Shiffmann on his online tutorial.

[Original project (Shakespeare)](https://github.com/shiffman/The-Nature-of-Code-Examples/tree/master/chp09_ga/NOC_9_01_GA_Shakespeare)

[YouTube video](https://www.youtube.com/playlist?list=PLRqwX-V7Uu6bJM3VgzjNV5YxVxUwzALHV)

## Running
Install [a working Elixir environement](https://elixir-lang.org/install.html).
Run `iex -S mix` in the terminal (no *sugar* shell, sorry).
Query the genetic algorithm with `Genetics.Evolution.guess/3`.

`guess/3` arguments are :

- **enigma**: `string` or `charlist` representing the targetted string to guess, defaults to the Shakespeare sentence (To be or not...) ;
- **population_size**: `integer` representing the size of the population used by the algorithm, defaults to 500 ;
- **mutation_rate**: `float` representing the probability of a mutation occuring after reproduction (0 <= n <= 1), defaults to 1%.

## Documentation
Currently not much of the code is documented. I've tried to do domain driver design (any feedback welcomed).

In `iex`, you can run `h Genetics.Evolution.guess`.

## Benchmarking
### Install bmark (dependency)
The benchmark uses [bmark](https://github.com/joekain/bmark).

Install it by entering `mix deps.get`

### Running bmark
Customize your benchmark by either editing the file `bmark/evolution_bmark.ex` or by adding a new file ending in `_bmark.ex` in the `bmark` directory.

Results appear in ms in the `results` folder.
