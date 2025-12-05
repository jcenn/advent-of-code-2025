Learning Odin through [Advent of Code 2025](https://adventofcode.com/)
## Dependencies
You need to have an odin compiler installed to build this project. For instructions see [odin getting started](https://odin-lang.org/docs/install/)
## Running
Inside the project directory run 
```
> odin build .
```
This should cause an executable file called `advent-of-code-2025` to appear in the project directory (note that executable's name might be different if this directory has been renamed)

Program picks which puzzle to run based on command line argument so running
```
> advent-of-code-2025 day_1
```
will print the solutions to both parts of the first day's puzzle.
Similarly providing (day_2/day_3/etc.) as the arguments will run puzzles from their respective days

## Example output
```
> ./advent-of-code-2025 day_1
part 1: 1007
part 2: 5820
```
