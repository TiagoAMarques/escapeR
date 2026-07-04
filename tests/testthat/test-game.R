test_that("rooms can be listed", {
  rooms <- list_rooms()
  expect_equal(nrow(rooms), 18)
  expect_true(all(c("room", "module", "title", "learning_goal") %in% names(rooms)))
})

test_that("game can start and accept first answer", {
  player <- paste0("test_", Sys.getpid())
  start_escape(player = player, reset = TRUE)
  expect_true(submit(42))
})

test_that("helper data have expected shape", {
  expect_equal(nrow(survey_counts()), 14)
  expect_equal(sum(is.na(survey_counts())), 2)
  expect_equal(nrow(read.csv(escapeR_file("dados1.csv"))), 25)
})
