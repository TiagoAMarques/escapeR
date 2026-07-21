test_that("rooms can be listed", {
  rooms <- list_rooms()
  expect_equal(nrow(rooms), 20)
  expect_true(all(c("room", "id", "module", "title", "learning_goal") %in% names(rooms)))
  expect_true(all(nchar(rooms$id) <= 8))
  expect_equal(tail(rooms$id, 2), c("webglm", "quarto"))
})

test_that("game can start and accept first answer", {
  player <- paste0("test_", Sys.getpid())
  escape(player = player, reset = TRUE)
  expect_true(submit(70))
})

test_that("escape command is not accepted as a player name", {
  expect_error(
    escape(player = "escape()"),
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
  expect_false("correct_result" %in% names(room))
  expect_false("checker" %in% names(room))
  expect_true(escapeR:::.check_room_answer("vector", 15))
  expect_false(escapeR:::.check_room_answer("vector", 7.5))
})

test_that("finding data room uses the Loblolly growth answer", {
  room <- escapeR:::.rooms()[[3]]
  expect_equal(room$id, "finddata")
  expect_equal(room$title, "Finding Data")
  expect_equal(length(room$hint), 2)
  expect_match(room$hint[[1]], "library\\(help = \"datasets\"\\)", fixed = FALSE)
  expect_equal(room$hint[[2]], "lolly is a candy :) ")
  expect_true(escapeR:::.check_room_answer("finddata", 3.36))
  expect_false(escapeR:::.check_room_answer("finddata", 2.86))
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
  checked <- new_room(
    id = "addon2",
    module = "Contributed rooms",
    title = "The Checked Door",
    learning_goal = "Use a custom answer checker.",
    introduction = "A second contributed room tests a flexible answer.",
    challenge = "Submit either R or r.",
    hints = "The language has a one-letter name.",
    checker = function(answer) identical(tolower(trimws(as.character(answer))), "r"),
    success = "The checked door opens."
  )

  expect_equal(addon$introduction, addon$story)
  expect_equal(addon$challenge, addon$task)
  expect_equal(addon$hints, addon$hint)
  register_rooms(addon, checked, replace = TRUE)

  custom <- build_escape(c("addon1", "addon2", "vector"))
  expect_equal(custom$room_ids, c("addon1", "addon2", "vector"))
  expect_equal(vapply(custom$rooms, `[[`, character(1), "id"), custom$room_ids)
  expect_true(all(vapply(custom$rooms, function(room) {
    !any(c("correct_result", "checker") %in% names(room))
  }, logical(1))))

  player <- paste0("custom_", Sys.getpid())
  escape(player = player, reset = TRUE, escape = custom)
  expect_true(submit(1))
  expect_equal(escapeR:::.state$progress$room, 2L)
  expect_false(submit("not r"))
  expect_true(submit(" R "))
  expect_equal(escapeR:::.state$progress$room, 3L)
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

test_that("bundled room packs are registered through the package hook", {
  bundled_room <- new_room(
    id = "hookroom",
    module = "Contributor test",
    title = "The Registration Hook",
    learning_goal = "Verify permanent pack integration.",
    introduction = "A contributed pack is waiting at package startup.",
    challenge = "Submit ready.",
    hints = "The expected word appears in the challenge.",
    correct_result = "ready",
    success = "The contributed pack is registered."
  )
  bundled_pack <- new_room_pack(
    id = "hookpack",
    title = "Registration hook test",
    description = "Checks the package-side bundled-pack registration path.",
    rooms = list(bundled_room),
    escapes = list(hookgame = "hookroom")
  )

  expect_equal(
    escapeR:::.register_bundled_room_packs(list(bundled_pack)),
    "hookpack"
  )
  expect_true("hookroom" %in% list_rooms()$id)
  expect_true("hookgame" %in% list_escapes()$id)
  expect_equal(build_escape("hookgame")$room_ids, "hookroom")
})

test_that("helper data have expected shape", {
  d <- survey_counts()
  expect_equal(nrow(d), 20)
  expect_equal(sum(is.na(survey_counts())), 2)
  expect_equal(sum(d$distance_m > 90 & d$detected), 2)
  expect_equal(read.csv(escapeR_file("survey_counts.csv")), d)
  expect_equal(nrow(read.csv(escapeR_file("dados1.csv"))), 25)
  expect_equal(system.file("extdata", "detection_plot_data.csv", package = "escapeR"), "")
  expect_true(file.exists(escapeR_file("datahide.txt")))
})

test_that("plotting room uses survey_counts data", {
  room <- escapeR:::.rooms()[[7]]
  expect_equal(room$id, "plotwin")
  expect_match(room$task, "survey_counts\\(\\)")
  expect_match(room$hint[[1]], "jitter\\(\\)")
  expect_true(escapeR:::.check_room_answer("plotwin", 2))
  expect_false("plot_detection" %in% getNamespaceExports("escapeR"))
})

test_that("hidden data room checks answer and custom failure message", {
  room <- escapeR:::.rooms()[[9]]
  expect_equal(room$title, "The Hidden Data")
  expect_equal(length(room$hint), 4)
  expect_match(room$hint[[2]], "read.table\\(\\)")
  expect_match(room$hint[[3]], "header")
  expect_match(room$hint[[4]], "\\?par")
  expect_true(escapeR:::.check_room_answer("hidden", " information "))
  expect_false(escapeR:::.check_room_answer("hidden", "data"))
  expect_equal(
    escapeR:::.failure_message(room),
    "That is not the information we are looking for; please try again!"
  )
})

test_that("web GLM room is before final room and checks rounded coefficient", {
  rooms <- escapeR:::.rooms()
  room <- rooms[[length(rooms) - 1L]]
  expect_equal(room$id, "webglm")
  expect_match(room$task, "species\\.richness")
  expect_match(room$task, "lat\\.sample")
  expect_equal(length(room$hint), 2)
  expect_match(room$hint[[1]], "glm\\(\\)")
  expect_match(room$hint[[2]], "coef\\(\\)")
  expect_true(escapeR:::.check_room_answer("webglm", 0.406))
  expect_false(escapeR:::.check_room_answer("webglm", 0.405))
  expect_equal(rooms[[length(rooms)]]$id, "quarto")
})

test_that("old default saved games migrate to include web GLM room", {
  old_ids <- c(
    "console", "vector", "finddata", "datatab", "columns", "missing",
    "plotwin", "habitat", "hidden", "subset", "sorting", "model",
    "resid", "predict", "detectp", "detect", "trunc", "comment",
    "quarto"
  )
  progress <- escapeR:::.new_progress("migration_test", escape_ids = old_ids)
  progress$room <- 19L

  migrated <- escapeR:::.migrate_progress(progress)

  expect_equal(tail(migrated$escape_ids, 2), c("webglm", "quarto"))
  expect_equal(escapeR:::.current_room(migrated)$id, "webglm")
})

test_that("completed or custom saved games are not migrated", {
  completed <- escapeR:::.new_progress("migration_done", escape_ids = c("comment", "quarto"))
  completed$completed <- TRUE
  custom <- escapeR:::.new_progress("migration_custom", escape_ids = c("comment", "quarto"))

  expect_equal(escapeR:::.migrate_progress(completed)$escape_ids, c("comment", "quarto"))
  expect_equal(escapeR:::.migrate_progress(custom)$escape_ids, c("comment", "quarto"))
})

test_that("old progress history shapes are normalized", {
  old_history <- data.frame(
    room = 1L,
    id = "console",
    solved_at = Sys.time(),
    stringsAsFactors = FALSE
  )

  normalized <- escapeR:::.normalize_history(old_history)

  expect_equal(names(normalized), c("room", "id", "title", "solved_at"))
  expect_equal(nrow(normalized), 1)
  expect_equal(normalized$id, "console")
  expect_true(is.na(normalized$title))
})

test_that("submit can append to old progress history", {
  builtin_ids <- escapeR:::.builtin_room_ids()
  progress <- escapeR:::.new_progress("old_history")
  progress$escape_ids <- builtin_ids
  progress$room <- 2L
  progress$history <- data.frame(
    room = 1L,
    id = "console",
    solved_at = Sys.time(),
    stringsAsFactors = FALSE
  )
  state <- getFromNamespace(".state", "escapeR")
  state$player <- progress$player
  state$progress <- progress

  expect_true(submit(15))
  expect_equal(names(state$progress$history), c("room", "id", "title", "solved_at"))
  expect_equal(nrow(state$progress$history), 2)
  expect_equal(tail(state$progress$history$id, 1), "vector")
})

test_that("final challenge responds to player choice", {
  expect_message(
    expect_message(
      escapeR:::.final_challenge("learner", choice = "Yes"),
      "You escaped the Ecological Statistics escape room",
      fixed = TRUE
    ),
    "The challenge: can you create new rooms",
    fixed = TRUE
  )

  expect_message(
    expect_message(
      escapeR:::.final_challenge("learner", choice = "Maybe"),
      "You escaped the Ecological Statistics escape room",
      fixed = TRUE
    ),
    "The challenge: can you create new rooms",
    fixed = TRUE
  )

  expect_message(
    expect_message(
      escapeR:::.final_challenge("learner", choice = "No"),
      "You escaped the Ecological Statistics escape room",
      fixed = TRUE
    ),
    "Fair enough. A bit lazy, but you R tired",
    fixed = TRUE
  )
})
