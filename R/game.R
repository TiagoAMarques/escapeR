#' Start or resume an escapeR game
#'
#' @param player Character scalar. If omitted in an interactive session, the
#'   player is asked for a name.
#' @param reset Logical. If `TRUE`, restart the named player's game.
#' @return Invisibly returns the current progress list.
start_escape <- function(player = NULL, reset = FALSE) {
  if (is.null(player)) {
    if (!interactive()) {
      stop("Please provide player = in non-interactive sessions.", call. = FALSE)
    }
    player <- readline("Who are you? ")
  }

  player <- trimws(as.character(player)[1])
  if (!nzchar(player)) {
    stop("Player name cannot be empty.", call. = FALSE)
  }

  if (isTRUE(reset)) {
    progress <- .new_progress(player)
    .save_progress(progress)
  } else {
    progress <- .load_progress(player)
  }

  .state$player <- player
  .state$progress <- progress

  message("Welcome, ", player, ".")
  play()
  invisible(progress)
}

#' Alias for starting the game
#'
#' @rdname start_escape
escape <- function(player = NULL, reset = FALSE) {
  start_escape(player = player, reset = reset)
}

#' Show the current room
#'
#' @return Invisibly returns the current room definition.
play <- function() {
  progress <- .require_game()

  if (isTRUE(progress$completed)) {
    message("You have already escaped. Run reset_game() to play again.")
    return(invisible(NULL))
  }

  room <- .current_room(progress)
  if (is.null(room)) {
    .state$progress$completed <- TRUE
    .save_progress(.state$progress)
    message("The final door is open. You escaped!")
    return(invisible(NULL))
  }

  cat("\n")
  cat("Room ", room$id, ": ", room$title, "\n", sep = "")
  cat(strrep("-", nchar(room$title) + 9), "\n", sep = "")
  cat(room$story, "\n\n", sep = "")
  cat("Task: ", room$task, "\n", sep = "")
  cat("Learning goal: ", room$learning_goal, "\n\n", sep = "")
  cat("When ready, call submit(your_answer). Use hint() if you need a nudge.\n")
  invisible(room)
}

#' Submit an answer for the current room
#'
#' @param answer The answer to check.
#' @return Invisibly returns `TRUE` for a correct answer and `FALSE` otherwise.
submit <- function(answer) {
  progress <- .require_game()
  room <- .current_room(progress)

  if (is.null(room)) {
    message("There is no locked door left.")
    return(invisible(TRUE))
  }

  ok <- isTRUE(room$checker(answer))
  if (!ok) {
    message(.failure_message(room))
    message("Try again, or call hint() if you want a nudge.")
    return(invisible(FALSE))
  }

  message(room$success)
  progress$history <- rbind(
    progress$history,
    data.frame(
      room = room$id,
      title = room$title,
      solved_at = Sys.time(),
      stringsAsFactors = FALSE
    )
  )
  progress$room <- progress$room + 1L
  if (progress$room > length(.rooms())) {
    progress$completed <- TRUE
  }
  .state$progress <- .save_progress(progress)

  if (isTRUE(progress$completed)) {
    message("Congratulations, ", progress$player, ". You escaped the ecological statistics room.")
  } else {
    play()
  }

  invisible(TRUE)
}

#' Show a hint for the current room
#'
#' @return Invisibly returns the hint text.
hint <- function() {
  progress <- .require_game()
  room <- .current_room(progress)
  if (is.null(room)) {
    message("No hints needed. The final door is already open.")
    return(invisible(NULL))
  }
  message(room$hint)
  invisible(room$hint)
}

#' Show player progress
#'
#' @return Invisibly returns the active progress list.
status <- function() {
  progress <- .require_game()
  total <- length(.rooms())
  solved <- max(0L, min(total, progress$room - 1L))
  message("Player: ", progress$player)
  message("Solved rooms: ", solved, " / ", total)
  if (isTRUE(progress$completed)) {
    message("Status: escaped")
  } else {
    message("Current room: ", progress$room)
  }
  invisible(progress)
}

#' Reset the active or named player game
#'
#' @param player Character scalar. Defaults to the active player.
#' @return Invisibly returns the reset progress list.
reset_game <- function(player = NULL) {
  if (is.null(player)) {
    if (is.null(.state$player)) {
      stop("No active player. Provide player = or run start_escape().", call. = FALSE)
    }
    player <- .state$player
  }
  progress <- .new_progress(player)
  .state$player <- player
  .state$progress <- .save_progress(progress)
  message("Progress reset for ", player, ".")
  play()
  invisible(progress)
}

#' List all escape rooms
#'
#' @return A data frame with room identifiers, modules, titles, and learning goals.
list_rooms <- function() {
  rooms <- .rooms()
  data.frame(
    room = as.integer(vapply(rooms, `[[`, numeric(1), "id")),
    module = vapply(rooms, `[[`, character(1), "module"),
    title = vapply(rooms, `[[`, character(1), "title"),
    learning_goal = vapply(rooms, `[[`, character(1), "learning_goal"),
    stringsAsFactors = FALSE
  )
}
