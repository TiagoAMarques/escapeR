.state <- new.env(parent = emptyenv())
.state$player <- NULL
.state$progress <- NULL

.progress_dir <- function() {
  path <- tools::R_user_dir("escapeR", which = "data")
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
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
    progress <- readRDS(file)
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
  saveRDS(progress, .progress_file(progress$player))
  invisible(progress)
}

.require_game <- function() {
  if (is.null(.state$progress)) {
    stop("No active escapeR game. Run escape() first.", call. = FALSE)
  }
  invisible(.state$progress)
}
