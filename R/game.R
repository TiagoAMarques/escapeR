#' Start or resume an escapeR game
#'
#' @param player Character scalar. If omitted in an interactive session, the
#'   player is asked for a name.
#' @param reset Logical. If `TRUE`, restart the named player's game.
#' @param escape Escape sequence created by `build_escape()`, or a character
#'   vector of room IDs. Defaults to the bundled room sequence.
#' @return Invisibly returns the current progress list.
#' @export
escape <- function(player = NULL, reset = FALSE, escape = NULL) {
  if (is.null(player)) {
    if (!interactive()) {
      stop("Please provide player = in non-interactive sessions.", call. = FALSE)
    }
    player <- readline("Player name: ")
  }

  player <- trimws(as.character(player)[1])
  if (!nzchar(player)) {
    stop("Player name cannot be empty.", call. = FALSE)
  }
  if (grepl("^(start_escape|escape)\\s*\\(", player)) {
    stop(
      "That looks like an R command, not a player name. Run escape() at the R prompt, then type only your name when asked.",
      call. = FALSE
    )
  }

  if (isTRUE(reset)) {
    progress <- .new_progress(player, escape_ids = .escape_ids(escape))
    .save_progress(progress)
  } else {
    progress <- .load_progress(player)
    if (!is.null(escape)) {
      progress <- .new_progress(player, escape_ids = .escape_ids(escape))
      .save_progress(progress)
    }
  }

  .state$player <- player
  .state$progress <- progress

  message("Welcome, ", player, ".")
  play()
  invisible(progress)
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
  cat("Room ", progress$room, " [", room$id, "]: ", room$title, "\n", sep = "")
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
      room = progress$room,
      id = room$id,
      title = room$title,
      solved_at = Sys.time(),
      stringsAsFactors = FALSE
    )
  )
  progress$room <- progress$room + 1L
  if (progress$room > length(.rooms(progress$escape_ids))) {
    progress$completed <- TRUE
  }
  .state$progress <- .save_progress(progress)

  if (isTRUE(progress$completed)) {
    .final_challenge(progress$player)
  } else {
    play()
  }

  invisible(TRUE)
}

.final_challenge <- function(player, choice = NULL) {
  message(
    "Congratulations, ", player,
    ". You escaped the Ecological Statistics escape room. All that with the power of R. A final never ending challenge remains. Are you up for it?"
  )

  options <- c("Yes", "No", "Maybe")
  if (is.null(choice)) {
    if (!interactive()) {
      choice <- "Maybe"
    } else {
      selection <- utils::menu(options, title = "Are you up for it?")
      choice <- if (selection %in% seq_along(options)) {
        options[[selection]]
      } else {
        "Maybe"
      }
    }
  }

  if (identical(.answer_text(choice), "no")) {
    message("Fair enough. A bit lazy, but you R tired, and you deserve a break. Maybe later ;)")
  } else {
    message("The challenge: can you create new rooms that are suitable to make the escape harder? Check out the vignette that shows you how you can do it!")
  }

  invisible(choice)
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

  hints <- room$hint
  room_key <- as.character(room$id)
  if (is.null(progress$hints)) {
    progress$hints <- integer()
  }
  used <- unname(progress$hints[room_key])
  if (is.na(used)) {
    used <- 0L
  }
  hint_index <- min(used + 1L, length(hints))
  progress$hints[room_key] <- hint_index
  .state$progress <- .save_progress(progress)

  message(hints[[hint_index]])
  invisible(hints[[hint_index]])
}

#' Show player progress
#'
#' @return Invisibly returns the active progress list.
status <- function() {
  progress <- .require_game()
  total <- length(.rooms(progress$escape_ids))
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
      stop("No active player. Provide player = or run escape().", call. = FALSE)
    }
    player <- .state$player
  }
  escape_ids <- if (is.null(.state$progress$escape_ids)) {
    .builtin_room_ids()
  } else {
    .state$progress$escape_ids
  }
  progress <- .new_progress(player, escape_ids = escape_ids)
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
  rooms <- .room_registry()
  data.frame(
    room = seq_along(rooms),
    id = vapply(rooms, `[[`, character(1), "id"),
    module = vapply(rooms, `[[`, character(1), "module"),
    title = vapply(rooms, `[[`, character(1), "title"),
    learning_goal = vapply(rooms, `[[`, character(1), "learning_goal"),
    stringsAsFactors = FALSE
  )
}
