test_that("rooms can be listed", {
  rooms <- list_rooms()
  expect_equal(nrow(rooms), 19)
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
  expect_equal(nrow(read.csv(escapeR_file("detection_plot_data.csv"))), 36)
  expect_true(file.exists(escapeR_file("datahide.txt")))
})

test_that("hidden data room checks answer and custom failure message", {
  room <- escapeR:::.rooms()[[9]]
  expect_equal(room$title, "The Hidden Data")
  expect_true(room$checker(" information "))
  expect_false(room$checker("data"))
  expect_equal(
    escapeR:::.failure_message(room),
    "That is not the information we are looking for; please try again!"
  )
})
