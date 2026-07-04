# escapeR

`escapeR` is an R package prototype for a classroom escape-room game. Students
learn R by solving small ecological-statistics puzzles: arithmetic, vectors,
CSV files, plots, subsetting, simple models, observation processes, and
reproducible Quarto workflows.

The first version is inspired by:

- `TiagoAMarques/AnIntro2RTutorial`, especially the beginner-friendly path from
  R as a calculator to data files, plots, commented code, and Quarto reports.
- The ecological-statistics course material, especially the idea that students
  need to reason from noisy observations back to ecological processes.
- The distance-sampling lesson, especially detection, distance, abundance,
  observation filters, and assumptions.

## Install from GitHub

Once the package folder has been pushed to GitHub as
`TiagoAMarques/escapeR`, students can install it directly from R:

```r
install.packages("remotes")
remotes::install_github("TiagoAMarques/escapeR")
```

Then:

```r
library(escapeR)
start_escape()
```

## Play

```r
library(escapeR)
start_escape()
```

Returning players can use the same name and continue from saved progress.

Useful commands:

```r
play()
hint()
submit(42)
status()
list_rooms()
reset_game()
```

Progress is saved with `tools::R_user_dir("escapeR", "data")`, so each student
can resume later on the same machine.

## Current room sequence

1. The Console Door: arithmetic and expressions.
2. The Vector Cabinet: vectors and summaries.
3. The Data Table Hatch: reading CSV files.
4. The Plotting Window: plotting detection against distance.
5. The Subsetting Lock: logical subsetting in data frames.
6. The Model Room: fitting and interpreting a simple model.
7. The Observation Filter: distance-sampling assumptions.
8. The Quarto Exit: reproducible reports.
