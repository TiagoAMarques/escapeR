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

.new_progress <- function(player) {
  list(
    player = player,
    room = 1L,
    started = Sys.time(),
    updated = Sys.time(),
    completed = FALSE,
    history = data.frame(
      room = integer(),
      title = character(),
      solved_at = as.POSIXct(character()),
      stringsAsFactors = FALSE
    )
  )
}

.load_progress <- function(player) {
  file <- .progress_file(player)
  if (file.exists(file)) {
    readRDS(file)
  } else {
    .new_progress(player)
  }
}

.save_progress <- function(progress) {
  progress$updated <- Sys.time()
  saveRDS(progress, .progress_file(progress$player))
  invisible(progress)
}

.require_game <- function() {
  if (is.null(.state$progress)) {
    stop("No active escapeR game. Run start_escape() first.", call. = FALSE)
  }
  invisible(.state$progress)
}
