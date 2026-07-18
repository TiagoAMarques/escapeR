test_that("rooms can be listed", {
  rooms <- list_rooms()
  expect_equal(nrow(rooms), 19)
  expect_true(all(c("room", "id", "module", "title", "learning_goal") %in% names(rooms)))
  expect_true(all(nchar(rooms$id) <= 8))
})

test_that("game can start and accept first answer", {
  player <- paste0("test_", Sys.getpid())
  start_escape(player = player, reset = TRUE)
  expect_true(submit(70))
})

test_that("start command is not accepted as a player name", {
  expect_error(
    start_escape(player = "start_escape()"),
    "looks like an R command"
  )
})

test_that("vector room has sequential hints and updated answer", {
  room <- escapeR:::.rooms()[[2]]
  expect_equal(room$id, "vector")
  expect_false(grepl("c\\(", room$task))
  expect_equal(length(room$hint), 2)
  expect_true(grepl("c\\(", room$hint[[1]]))
  expect_true(grepl("seq\\(1, 29, 4\\)", room$hint[[2]]))
  expect_true(room$checker(15))
  expect_false(room$checker(7.5))
})

test_that("custom rooms can be registered and composed", {
  addon <- new_room(
    id = "addon1",
    module = "Contributed rooms",
    title = "The Add-on Door",
    learning_goal = "Compose a custom escape.",
    introduction = "A contributed room appears beside the main corridor.",
    challenge = "Submit the number of letters in R.",
    hints = c("R has a very short name.", "It is one letter."),
    correct_result = 1,
    success = "The add-on door opens."
  )

  expect_equal(addon$introduction, addon$story)
  expect_equal(addon$challenge, addon$task)
  expect_equal(addon$hints, addon$hint)
  register_rooms(addon, replace = TRUE)

  custom <- build_escape(c("addon1", "vector"))
  expect_equal(custom$room_ids, c("addon1", "vector"))
  expect_equal(vapply(custom$rooms, `[[`, character(1), "id"), custom$room_ids)

  player <- paste0("custom_", Sys.getpid())
  start_escape(player = player, reset = TRUE, escape = custom)
  expect_true(submit(1))
  expect_equal(escapeR:::.state$progress$room, 2L)
})

test_that("room packs register rooms and named escapes", {
  med_room1 <- new_room(
    id = "bpmean",
    module = "Medicine",
    title = "The Clinic Intake",
    learning_goal = "Calculate a mean from a small numeric vector.",
    introduction = "A clinic intake sheet lists systolic blood pressure readings.",
    challenge = "Create a vector with 120, 130, and 140. Submit the mean.",
    hints = c("Use c() to create the vector.", "mean() calculates the average."),
    correct_result = 130,
    success = "The intake form is complete."
  )
  med_room2 <- new_room(
    id = "riskcat",
    module = "Medicine",
    title = "The Risk Label",
    learning_goal = "Classify a numeric result.",
    introduction = "A label printer waits for the correct risk category.",
    challenge = "Submit high if 145 is above the threshold 140.",
    hints = "Use a logical comparison such as 145 > 140.",
    correct_result = "high",
    success = "The label prints clearly."
  )
  pack <- new_room_pack(
    id = "medpack",
    title = "Medicine practice rooms",
    description = "A tiny pack for clinical-data examples.",
    rooms = list(med_room1, med_room2),
    escapes = list(medmini = c("bpmean", "riskcat"))
  )

  register_room_pack(pack, replace = TRUE)
  expect_true(all(c("bpmean", "riskcat") %in% list_rooms()$id))
  expect_true("medmini" %in% list_escapes()$id)
  expect_equal(build_escape("medmini")$room_ids, c("bpmean", "riskcat"))
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
