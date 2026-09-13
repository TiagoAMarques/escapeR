# Ecologia Numérica: teacher guide

This pack contains 25 playable rooms, one per supplied lecture deck. Students
enter with `escape(player = "name", escape = "en2026")`. The `enintro` sequence
contains only room 1. To resume a saved semester, use `escape(player = "name")`
without the `escape` argument; supplying it starts a new sequence.

Each room has three progressive hints. The last hint gives a reproducible R
solution, so teachers can decide how much help to encourage. Numerical checkers
accept a single finite number or numeric string. Where rounding is requested,
unrounded answers that round correctly also work; exact tasks use numerical
tolerance without rounding. Room 19 accepts the text
`GAM`, ignoring case and surrounding whitespace.

## Lecture mapping

Source directory supplied by the teacher:
`C:/Users/tiago/OneDrive - University of St Andrews/Trabalho/FCUL/AulasPorAno/2026_2027/EN2026/AulasT`.
Decks T01–T02 are in `Novos`, T03–T25 in `Velhos`. References below use slide
numbers in the PPTX files. Some old slide covers still display earlier years;
the sequence follows the T01–T25 filenames, rather than those cover dates.
Supplementary decks and the video are not assigned separate rooms.

| Room | Deck | Relevant slides | Lecture focus selected for the puzzle | Answer |
| --- | --- | --- | --- | --- |
| en01 | Novos/T01_EN_14Sep2026.pptx | 31, 46 | Introduction; R as a calculator | 5.24 minutes |
| en02 | Novos/T02_EN_15Sep2026.pptx | 18–24 | Critical thinking; observation filters | 30 birds |
| en03 | Velhos/T03_EN_21Sep2026.pptx | 36–45 | Scientific method; testable predictions | 14 |
| en04 | Velhos/T04_EN_22Sep2026.pptx | 43–50 | Probability unions and intersections | 0.70 |
| en05 | Velhos/T05_EN_28Sep2026.pptx | 34–41 | Random variables; binomial distribution | 0.3115 |
| en06 | Velhos/T06_EN_29Sep2026.pptx | 13–15 | Distribution functions in R | 0.0228 |
| en07 | Velhos/T07_EN_06Oct2026.pptx | 23–29 | Stratified sampling | 14 plants/quadrat |
| en08 | Velhos/T08_EN_12Oct2026.pptx | 20–28 | Experimental units; pseudoreplication | 6 tanks |
| en09 | Velhos/T09_EN_13Oct2026.pptx | 30–32, 55–57 | Graphics; centring and scaling | 1.26 |
| en10 | Velhos/T10_EN_19Oct2026.pptx | 14–16, 26, 34 | Hypothesis testing; exact sign-test p-value | 0.0703 |
| en11 | Velhos/T11_EN_20Oct2026.pptx | 11–15, 49–54 | Assumptions; one-sample t-test | 1.414 |
| en12 | Velhos/T12_EN_26Oct2026.pptx | 8–16 | Wilcoxon signed ranks | 24 |
| en13 | Velhos/T13_EN_27Oct2026.pptx | 31–46 | Comparing several means; one-way ANOVA | 27 |
| en14 | Velhos/T14_EN_02Nov2026.pptx | 26–43 | Factorial ANOVA; interaction | 4 cm |
| en15 | Velhos/T15_EN_03Nov2026.pptx | 15–20 | Blocks and paired comparisons | 2.5 cm |
| en16 | Velhos/T16_EN_09Nov2026.pptx | 18–27 | Linear regression; slope | 1.70 |
| en17 | Velhos/T17_EN_10Nov2026.pptx | 21–35 | Residuals and model diagnostics | Observation 3 |
| en18 | Velhos/T18_EN_16Nov2026.pptx | 21–30, 34 | GLM inverse link | 0.7311 |
| en19 | Velhos/T19_EN_17Nov2026.pptx | 20–28 | GAMs and smooth effects | GAM |
| en20 | Velhos/T20_EN_23Nov2026.pptx | 30–36 | Contingency tables; independence | 21.78 |
| en21 | Velhos/T21_EN_24Nov2026.pptx | 26–29 | Maximum likelihood | 0.40 |
| en22 | Velhos/T22_EN_30Nov2026.pptx | 21–26 | Community matrices; column means | 6 newts/pond |
| en23 | Velhos/T23_EN_07Dec2026.pptx | 24, 29–30 | Presence-absence distances; Jaccard | 0.50 |
| en24 | Velhos/T24_EN_14Dec2026.pptx | 31–34 | Non-hierarchical clustering; k-means | 9 |
| en25 | Velhos/T25_EN_15Dec2026.pptx | 13–20, 30 | PCA; variance explained | 80.0% |

This is a small puzzle for a selected concept from each lecture, rather than a
replacement for every topic in the lecture. Room 19 is a conceptual model-choice
question supported by a plot; fitting a GAM is optional independent exploration.
All required calculations use base R and its standard `stats` package.

## Data provenance and teaching choices

Room 1 retains the requested story and animal speed. Coordinates are explicitly
in metres, an authoring assumption needed to make the time unique. The path is
straight and speed is treated as constant. Thus distance is sqrt(2) metres,
and time is sqrt(2) * 100 / 27 minutes.

Room 12 reuses the numerical signed-rank example from T12 slide 14, with an
illustrative shell context. Room 20 reuses the sex-by-colour counts from T20
slide 36. Room 21 reuses the nest sequence from T21 slides 26–29. Other small
datasets and numerical models were created for these teaching puzzles; they
are not observations or fitted results from an actual ecological study.
The source presentations are not copied into the package.

The likelihood room uses L(theta; x) = P(x | theta) as a function of theta for
fixed observations. Some source slides label this as P(theta | x); the room
distinguishes likelihood from a posterior probability, which requires a prior
and Bayes' rule.

Important discussion points:

- en02: detection correction is an estimate under the given observation model.
- en05: the binomial model assumes independent trials and common success probability.
- en08: there are three independent tanks per treatment, six in total; 30 fish are subsamples.
- en10: p = 0.0703125 leads to non-rejection at alpha = 0.05, without proving H0.
- en11 and en13: Normality and equal-variance assumptions are stipulated for the exercise where needed. They are not established by these tiny datasets.
- en12: signed-rank location inference needs symmetry as well as independence.
- en14: a difference of effects describes interaction; four means without replication or uncertainty do not test its significance.
- en17: investigate a large residual; do not automatically remove that observation. With five observations, diagnostic plots have limited power.
- en19: the comparison specifies a linear temperature term in the GLM. GLMs can also use nonlinear predictor bases; GAMs offer smooth terms with complexity control.
- en23: joint absences do not enter Jaccard similarity. Both example islands have at least one species present, so the union is nonzero.
- en24: initial centres are explicit, so no random seed is needed; cluster labels have no ecological meaning.
- en25: the puzzle centres but does not scale. Using other units or choosing unit-variance scaling changes the interpretation; PCA axis signs may vary, but variance shares do not.

## Worked R solutions

The following calculations match the student questions. Each numbered comment
corresponds to the lecture and room ID. Submit the final result of each section
while playing that room. Most calculations can also be expressed in other ways.

```r
# 01: distance in metres, converted to centimetres; time in minutes
round(sqrt((2 - 3)^2 + (5 - 4)^2) * 100 / 27, 2)

# 02: correct the observation filter
18 / 0.6

# 03: a testable model prediction
20 - 3 * 2

# 04: probability of a union
0.4 + 0.5 - 0.2

# 05: exactly two successes
round(dbinom(2, size = 8, prob = 0.25), 4)

# 06: upper-tail probability
round(pnorm(24, mean = 20, sd = 2, lower.tail = FALSE), 4)

# 07: stratified estimate of the overall mean
weighted.mean(c(10, 30), c(80, 20))

# 08: count independent experimental units
tank <- rep(1:6, each = 5)
length(unique(tank))

# 09: inspect and standardise
height <- c(2, 4, 6, 8, 10)
boxplot(height)
round(as.numeric(scale(height))[5], 2)

# 10: exact two-sided sign test
round(binom.test(7, 8, p = 0.5)$p.value, 4)

# 11: one-sample t statistic
round(unname(t.test(c(4, 5, 6, 7, 8), mu = 5)$statistic), 3)

# 12: positive signed ranks
shell <- c(2.2, 2.8, 1.1, 4.3, 2.5, 5.6, 0.3, 1.9)
difference <- shell - 2
sum(rank(abs(difference))[difference > 0])
# Equivalent: unname(wilcox.test(shell, mu = 2)$statistic)

# 13: one-way ANOVA
count <- c(2, 3, 4, 5, 6, 7, 8, 9, 10)
meadow <- factor(rep(c("A", "B", "C"), each = 3))
summary(aov(count ~ meadow))[[1]][["F value"]][1]

# 14: interaction contrast
(10 - 4) - (5 - 3)

# 15: differences within blocks
mean(c(12, 23, 31, 44) - c(10, 20, 30, 40))

# 16: regression slope
nutrient <- c(1, 2, 3, 4, 5)
biomass <- c(3, 5, 4, 8, 10)
model <- lm(biomass ~ nutrient)
unname(coef(model)["nutrient"])

# 17: self-contained regression diagnostics
nutrient <- c(1, 2, 3, 4, 5)
biomass <- c(3, 5, 4, 8, 10)
model <- lm(biomass ~ nutrient)
plot(fitted(model), residuals(model))
qqnorm(residuals(model))
qqline(residuals(model))
which.max(abs(residuals(model)))

# 18: inverse logit
round(plogis(-2 + 0.5 * 6), 4)

# 19: recognize a smooth effect
temperature <- 0:10
growth <- c(1, 2, 4, 7, 9, 10, 9, 7, 4, 2, 1)
plot(temperature, growth, type = "b")
"GAM"

# 20: expected cell count under independence
tab <- rbind(male = c(10, 23, 52), female = c(31, 25, 19))
round(rowSums(tab)[1] * colSums(tab)[1] / sum(tab), 2)

# 21: maximum likelihood by grid search
theta <- seq(0, 1, by = 0.01)
likelihood <- theta^2 * (1 - theta)^3
plot(theta, likelihood, type = "l")
theta[which.max(likelihood)]

# 22: species means across sites
community <- rbind(A = c(frog = 2, newt = 8),
                   B = c(frog = 4, newt = 6),
                   C = c(frog = 6, newt = 4))
unname(colMeans(community)["newt"])

# 23: binary Jaccard dissimilarity
a <- c(1, 1, 0, 0, 1)
b <- c(1, 0, 1, 0, 1)
1 - sum(a == 1 & b == 1) / sum(a == 1 | b == 1)

# 24: k-means with explicit initial centres
x <- rbind(A = c(1, 1), B = c(1, 2), C = c(9, 9), D = c(9, 10))
km <- kmeans(x, centers = x[c(1, 3), ])
max(km$centers[, 1])

# 25: variance share, independent of PCA axis signs
x <- rbind(c(1, 2), c(2, 1), c(3, 4), c(4, 3))
pca <- prcomp(x, center = TRUE, scale. = FALSE)
variance <- pca$sdev^2
plot(variance, type = "b")
round(100 * variance[1] / sum(variance), 1)
```

## Extending a lecture room

Edit its entry in `R/en-lessons.R`; room 1 is in
`R/room-pack-ecologia-numerica.R`. Keep `en01`–`en25` stable so saved room
sequences remain usable. Each entry names its lecture topic and slide references,
learning goal, story, question, hints, answer, success message, and numerical
rounding. If a question or answer changes, update its independently computed
solution in `tests/testthat/test-ecologia-numerica.R` and this guide.
