## Submission

First submission. escapeR provides console-based ecological-statistics puzzles,
saved player progress, and tools for instructors to create rooms and room packs.

## Test environment

* Local Windows 11 x64, R 4.6.0 (2026-04-24 ucrt), 14 September 2026.
* Source archive built with R CMD build, including all three vignettes.
* Full R CMD check --as-cran, including PDF and HTML manuals and rebuilt vignettes.
* Suggested dependencies required during checking.

## Check results

0 errors | 0 warnings | 2 notes

* New submission: expected for this first release.
* Temporary-directory detritus: lastMiKTeXException. Both PDF and HTML manual
  checks pass. This appears to be a Windows TeX-toolchain artifact, similar to
  the issue discussed at
  https://stat.ethz.ch/pipermail/r-package-devel/2022q1/007893.html.

Tests: 466 passing assertions, no failures, warnings or skips.

Other-platform and R-devel results must be added after those checks have run.
