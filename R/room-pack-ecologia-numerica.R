# Lecture-aligned pack. See inst/course-guides/ecologia-numerica.md for teaching notes.
ecologia_numerica_room_pack <- function() {
  plan <- .en_class_plan()
  first <- new_room(
    id = "en01",
    module = "Ecologia Num\u00e9rica - Class 01",
    title = "The First Practical Class",
    learning_goal = plan$goal[[1]],
    introduction = paste(
      "You find yourself locked in the first practical class of Ecologica Num\u00e9rica.",
      "You are not locked in the physical world, but you can't escape the virtual world.",
      "A devious malefic teacher has developed a cunning plan to force you to learn R and numerical ecology at the same time.",
      "There's no way out but to play the game.",
      "And hope you can escapeR - ha ha ha (even if this does not sound like, this is an ominous laughter!)"
    ),
    challenge = paste(
      "Use R as a simple calculator. An animal moves on average at 27 cm per minute.",
      "How long will it take to go in a straight line from point A at (3,4) to point B at (2,5)?",
      "Both coordinates are in metres. Assume a constant speed of 27 cm per minute.",
      "Submit the travel time in minutes, rounded to two decimal places."
    ),
    hints = c(
      "The straight-line distance follows Pythagoras: square each coordinate difference, add them, then take the square root.",
      "R uses ^ for powers and sqrt() for square roots. Convert metres to centimetres before dividing by the speed.",
      "Try round(sqrt((2 - 3)^2 + (5 - 4)^2) * 100 / 27, 2), then submit the result."
    ),
    correct_result = round(sqrt(2) * 100 / 27, 2),
    checker = .en_number_checker(5.24, 2L),
    success = "The first virtual door opens. Your calculator is R, and your escape has begun!",
    failure = "Check the straight-line distance, convert metres to centimetres, and submit minutes rounded to two decimal places."
  )

  lessons <- .en_lessons()
  later_rooms <- lapply(2:25, function(i) {
    lesson <- lessons[[i - 1L]]
    new_room(
      id = plan$id[[i]],
      module = sprintf("Ecologia Num\u00e9rica - Lecture %02d: %s", i, lesson$topic),
      title = lesson$title,
      learning_goal = plan$goal[[i]],
      introduction = lesson$story,
      challenge = lesson$challenge,
      hints = lesson$hints,
      correct_result = lesson$answer,
      checker = if (is.numeric(lesson$answer)) .en_number_checker(lesson$answer, lesson$digits) else NULL,
      success = lesson$success,
      failure = "The virtual lock stays shut. Check the requested quantity and units, or reveal the next hint."
    )
  })

  rooms <- c(list(first), later_rooms)
  for (i in seq_along(rooms)) {
    rooms[[i]]$lecture <- i
    rooms[[i]]$lecture_file <- plan$source[[i]]
    rooms[[i]]$lecture_slides <- if (i == 1L) c(31L, 46L) else lessons[[i - 1L]]$slides
  }

  new_room_pack(
    id = "enpack",
    title = "Ecologia Num\u00e9rica",
    description = "25 lecture-aligned rooms for third-year statistics for ecologists, from R arithmetic to PCA.",
    rooms = rooms,
    escapes = list(enintro = "en01", en2026 = plan$id)
  )
}
