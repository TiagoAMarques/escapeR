.state <- new.env(parent = emptyenv())
.state$player <- NULL
.state$progress <- NULL

.progress_dir <- function() {
  path <- getOption("escapeR.progress_dir", tools::R_user_dir("escapeR", which = "data"))
  if (!is.character(path) || length(path) != 1L || is.na(path) || !nzchar(path)) stop("Invalid escapeR.progress_dir option.", call. = FALSE)
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  if (!dir.exists(path)) stop("Cannot create progress directory: ", path, call. = FALSE)
  path
}

.progress_file <- function(player) {
  safe <- gsub("[^A-Za-z0-9_-]+", "_", tolower(player))
  file.path(.progress_dir(), paste0(safe, ".rds"))
}

.new_progress <- function(player, escape_ids = NULL) {
  list(
    player = player,
    room = 1L,
    escape_ids = .escape_ids(escape_ids),
    started = Sys.time(),
    updated = Sys.time(),
    completed = FALSE,
    hints = integer(),
    history = .empty_history()
  )
}

.load_progress <- function(player) {
  file <- .progress_file(player)
  if (file.exists(file)) {
    progress <- tryCatch(readRDS(file), error = function(e) {
      stop("Cannot read saved progress. Use delete_progress(player) or restart with reset = TRUE.", call. = FALSE)
    })
    if (!is.list(progress) || !is.character(progress$player) || length(progress$player) != 1L || is.na(progress$player) || !is.numeric(progress$room) || length(progress$room) != 1L || is.na(progress$room) || !is.finite(progress$room) || progress$room < 1) {
      stop("Invalid saved progress. Use delete_progress(player) or restart with reset = TRUE.", call. = FALSE)
    }
    if (!identical(tolower(progress$player), tolower(player))) {
      stop("This player name maps to another saved profile. Choose a different name.", call. = FALSE)
    }
    if (is.null(progress$escape_ids)) {
      progress$escape_ids <- .builtin_room_ids()
    }
    if (is.null(progress$hints)) {
      progress$hints <- integer()
    }
    progress <- .migrate_progress(progress)
    .save_progress(progress)
  } else {
    .new_progress(player)
  }
}

.migrate_progress <- function(progress) {
  old_builtin_ids <- c(
    "console", "vector", "finddata", "datatab", "columns", "missing",
    "plotwin", "habitat", "hidden", "subset", "sorting", "model",
    "resid", "predict", "detectp", "detect", "trunc", "comment",
    "quarto"
  )

  if (
    !isTRUE(progress$completed) &&
      identical(progress$escape_ids, old_builtin_ids)
  ) {
    progress$escape_ids <- .builtin_room_ids()
  }

  progress$history <- .normalize_history(progress$history)

  progress
}

.empty_history <- function() {
  data.frame(
    room = integer(),
    id = character(),
    title = character(),
    solved_at = as.POSIXct(character()),
    stringsAsFactors = FALSE
  )
}

.normalize_history <- function(history) {
  if (is.null(history) || !is.data.frame(history)) {
    return(.empty_history())
  }

  n <- nrow(history)
  if (!"room" %in% names(history)) {
    history$room <- rep(NA_integer_, n)
  }
  if (!"id" %in% names(history)) {
    history$id <- rep(NA_character_, n)
  }
  if (!"title" %in% names(history)) {
    history$title <- rep(NA_character_, n)
  }
  if (!"solved_at" %in% names(history)) {
    history$solved_at <- as.POSIXct(rep(NA_character_, n))
  }

  data.frame(
    room = as.integer(history$room),
    id = as.character(history$id),
    title = as.character(history$title),
    solved_at = as.POSIXct(history$solved_at),
    stringsAsFactors = FALSE
  )
}

.save_progress <- function(progress) {
  progress$updated <- Sys.time()
  file <- .progress_file(progress$player)
  if (file.exists(file)) {
    saved <- tryCatch(readRDS(file), error = function(e) NULL)
    if (is.list(saved) && is.character(saved$player) && length(saved$player) == 1L && !is.na(saved$player) && !identical(tolower(saved$player), tolower(progress$player))) {
      stop("This player name maps to another saved profile. Choose a different name.", call. = FALSE)
    }
  }
  saveRDS(progress, file)
  invisible(progress)
}

.require_game <- function() {
  if (is.null(.state$progress)) {
    stop("No active escapeR game. Run escape() first.", call. = FALSE)
  }
  invisible(.state$progress)
}

#' Delete a saved player profile
#'
#' @param player Single non-empty player name. Defaults to the active player.
#' @return Invisibly returns whether a saved file was removed.
#' @details Progress is stored in the per-user data directory returned by
#'   `tools::R_user_dir()`. Set `options(escapeR.progress_dir = path)` to choose
#'   another directory, including temporary storage for demonstrations.
#'   Delete profiles when they are no longer needed. Player filenames are
#'   case-insensitive and punctuation is replaced by underscores.
#' @export
#' @examples
#' local({
#'   path <- tempfile("escapeR-demo-")
#'   old <- options(escapeR.progress_dir = path)
#'   on.exit(options(old))
#'   on.exit(unlink(path, recursive = TRUE), add = TRUE)
#'   escape(player = "demo", reset = TRUE)
#'   submit(70)
#'   delete_progress("demo")
#' })
delete_progress <- function(player = .state$player) {
  if (!is.character(player) || length(player) != 1L || is.na(player) ||
      !nzchar(trimws(player))) {
    stop("Provide a single non-empty player name.", call. = FALSE)
  }
  player <- trimws(player)
  file <- .progress_file(player)
  removed <- file.exists(file)
  if (removed && !file.remove(file)) stop("Cannot remove saved progress.", call. = FALSE)
  if (!is.null(.state$player) && identical(.progress_file(.state$player), file)) {
    .state$player <- NULL
    .state$progress <- NULL
  }
  invisible(removed)
}
