# escapeR

`escapeR` is an R package prototype for a classroom escape-room game. Students
learn R by solving small ecological-statistics puzzles: arithmetic, vectors,
objects, CSV files, data inspection, plots, subsetting, simple models,
predictions, observation processes, distance-sampling ideas, and reproducible
Quarto workflows.

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

The current game has 19 rooms arranged across seven course modules:

1. R foundations: console arithmetic, vectors, and named objects.
2. Data import and inspection: CSV import, column names, and missing values.
3. Visualisation: detection plots, categorical summaries, and hidden structure in data.
4. Data manipulation: subsetting and ordering data frames.
5. Ecological modelling: model fitting, residuals, and prediction.
6. Distance sampling: observation processes, detections, and truncation.
7. Reproducible workflow: comments and Quarto source files.

Use `list_rooms()` to see every room, module, and learning goal.

Wrong answers now return a short encouraging message that points students back
to the habits that make R and statistics useful for ecologists: checking object
names, inspecting data structure, iterating carefully, and treating models as
tools for thinking rather than magic doors.

## Instructor notes

This is intentionally small and dependency-light. It can grow in several
directions:

- more rooms per course module;
- Portuguese and English text modes;
- instructor-authored room packs;
- Shiny or learnr front ends;
- classroom leaderboards;
- automated export of student progress.
