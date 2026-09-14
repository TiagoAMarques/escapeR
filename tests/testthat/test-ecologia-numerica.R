.en_test_answers <- function() {
  heights <- c(2, 4, 6, 8, 10)
  growth <- c(4, 5, 6, 7, 8)
  shells <- c(2.2, 2.8, 1.1, 4.3, 2.5, 5.6, 0.3, 1.9)
  count <- 2:10
  meadow <- factor(rep(c("A", "B", "C"), each = 3))
  nutrient <- 1:5
  biomass <- c(3, 5, 4, 8, 10)
  model <- lm(biomass ~ nutrient)
  tab <- rbind(c(10, 23, 52), c(31, 25, 19))
  theta <- seq(0, 1, by = 0.01)
  likelihood <- theta^2 * (1 - theta)^3
  community <- rbind(c(2, 8), c(4, 6), c(6, 4))
  a <- c(1, 1, 0, 0, 1)
  b <- c(1, 0, 1, 0, 1)
  sites <- rbind(c(1, 1), c(1, 2), c(9, 9), c(9, 10))
  clusters <- kmeans(sites, centers = sites[c(1, 3), ])
  pca <- prcomp(rbind(c(1, 2), c(2, 1), c(3, 4), c(4, 3)),
                center = TRUE, scale. = FALSE)
  list(
    sqrt((2 - 3)^2 + (5 - 4)^2) * 100 / 27,
    18 / 0.6,
    20 - 3 * 2,
    0.4 + 0.5 - 0.2,
    dbinom(2, 8, 0.25),
    pnorm(24, 20, 2, lower.tail = FALSE),
    weighted.mean(c(10, 30), c(80, 20)),
    length(unique(rep(1:6, each = 5))),
    (10 - mean(heights)) / sd(heights),
    binom.test(7, 8, p = 0.5)$p.value,
    (mean(growth) - 5) / (sd(growth) / sqrt(length(growth))),
    unname(wilcox.test(shells, mu = 2)$statistic),
    summary(aov(count ~ meadow))[[1]][["F value"]][1],
    (10 - 4) - (5 - 3),
    mean(c(12, 23, 31, 44) - c(10, 20, 30, 40)),
    unname(coef(model)["nutrient"]),
    which.max(abs(biomass - fitted(model))),
    1 / (1 + exp(-(-2 + 0.5 * 6))),
    "GAM",
    chisq.test(tab)$expected[1, 1],
    theta[which.max(likelihood)],
    colMeans(community)[2],
    1 - sum(a == 1 & b == 1) / sum(a == 1 | b == 1),
    max(clusters$centers[, 1]),
    100 * pca$sdev[1]^2 / sum(pca$sdev^2)
  )
}

test_that("the EN course is bundled in lecture order with source references", {
  local_test_progress()
  sequence <- build_escape("en2026")
  expect_equal(sequence$room_ids, sprintf("en%02d", 1:25))
  expect_equal(build_escape("enintro")$room_ids, "en01")
  expect_true(all(sequence$room_ids %in% list_rooms()$id))
  expect_equal(vapply(sequence$rooms, `[[`, integer(1), "lecture"), 1:25)
  expect_match(sequence$rooms[[1]]$lecture_file, "^Novos/T01_")
  expect_match(sequence$rooms[[25]]$lecture_file, "^Velhos/T25_")
  expect_true(all(vapply(sequence$rooms, function(room) {
    length(room$hints) == 3 && length(room$lecture_slides) > 0 &&
      !any(c("correct_result", "checker") %in% names(room))
  }, logical(1))))
  expect_match(sequence$rooms[[1]]$introduction, "A devious malefic teacher", fixed = TRUE)
  expect_match(sequence$rooms[[1]]$challenge, "coordinates are in metres", fixed = TRUE)
})

test_that("independently calculated ecological answers unlock every EN room", {
  local_test_progress()
  answers <- .en_test_answers()
  for (i in seq_along(answers)) {
    id <- sprintf("en%02d", i)
    expect_true(escapeR:::.check_room_answer(id, answers[[i]]), info = id)
    if (is.numeric(answers[[i]])) {
      expect_false(escapeR:::.check_room_answer(id, answers[[i]] + 1), info = id)
      for (bad in list(NA_real_, NaN, Inf, -Inf, TRUE, numeric(), c(1, 2),
                       list(answers[[i]]), "not a number", 1 + 1i)) {
        expect_false(escapeR:::.check_room_answer(id, bad), info = id)
      }
    }
  }
  expect_true(escapeR:::.check_room_answer("en01", " 5.24 "))
  expect_false(escapeR:::.check_room_answer("en01", sqrt(2) / 27))
  expect_false(escapeR:::.check_room_answer("en08", 30))
  expect_false(escapeR:::.check_room_answer("en08", 5.6))
  expect_false(escapeR:::.check_room_answer("en17", 3.4))
  expect_false(escapeR:::.check_room_answer("en04", 0.704))
  expect_false(escapeR:::.check_room_answer("en19", "GLM"))
  expect_true(escapeR:::.check_room_answer("en19", " gam "))
  expect_false(escapeR:::.check_room_answer("en25", 0.8))
})

test_that("students can play all 25 EN rooms and resume their saved sequence", {
  local_test_progress()
  player <- paste0("en_semester_", Sys.getpid())
  escape(player = player, reset = TRUE, escape = "en2026")
  expect_false(submit(0))
  expect_equal(escapeR:::.state$progress$room, 1L)
  answers <- .en_test_answers()
  for (i in seq_along(answers)) {
    expect_equal(escapeR:::.current_room(escapeR:::.state$progress)$id, sprintf("en%02d", i))
    expect_true(submit(answers[[i]]))
    if (i == 12L) {
      escape(player = player)
      expect_equal(escapeR:::.state$progress$room, 13L)
      expect_equal(escapeR:::.state$progress$escape_ids, sprintf("en%02d", 1:25))
    }
  }
  expect_true(escapeR:::.state$progress$completed)
  expect_equal(escapeR:::.state$progress$history$id, sprintf("en%02d", 1:25))
})
