# escapeR

`escapeR` is an R package prototype for a classroom escape-room game. Students
learn R by solving small ecological-statistics puzzles: arithmetic, vectors,
objects, CSV files, data inspection, plots, subsetting, simple models,
predictions, observation processes, distance-sampling ideas, and reproducible
Quarto workflows.

![The escapeR Educational Experience](man/figures/The_escapeR_Educational_Experience.png)

Please do not get your expectations too high. This is currently a pet project
that started as a great way to procrastinate while preparing my habilitation
process. The image above reflects a vision; the reality might not live up to the
expectation yet.

![The escapeR Expectation vs Reality](man/figures/escapeR_Expectation_vs_Reality.png)

The first version is inspired by:

- `TiagoAMarques/AnIntro2RTutorial`, especially the beginner-friendly path from
  R as a calculator to data files, plots, commented code, and Quarto reports.
- The Ecological Statistics course material, especially the idea that students
  need to reason from noisy observations back to ecological processes.
- The Distance Sampling lesson, especially detection, distance, abundance,
  observation filters, and assumptions.

If you have suggestions for rooms, please reach out. I would be happy to have
co-authors on this package :)

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
escape()
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

For a fuller walkthrough, see:

```r
vignette("getting-started-with-escapeR", package = "escapeR")
```

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

## Custom room sequences

Rooms are modular objects with a short ID, introduction text, challenge text,
sequential hints, an answer checker, success text, and optional failure text.
Instructors can compose a shorter or themed escape from room IDs:

```r
river_escape <- build_escape(c("console", "vector", "plotwin"))
escape(player = "student1", reset = TRUE, escape = river_escape)
```

Contributors can also create and register add-on rooms:

```r
parasite_room <- new_room(
  id = "paras",
  module = "R foundations",
  title = "The Parasite Count",
  learning_goal = "Create vectors and summarize them.",
  introduction = "A sample tray holds river fish records.",
  challenge = "Submit the mean parasite count.",
  hints = c("Store the counts in a vector first.", "mean() calculates the average."),
  correct_result = 15,
  success = "The tray label clicks into place."
)

register_rooms(parasite_room)
build_escape(c("console", "paras"))
```

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
