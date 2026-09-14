local_test_progress <- function(env = parent.frame()) {
  savedir <- withr::local_tempdir(.local_envir = env)
  withr::local_options(list(escapeR.progress_dir = savedir), .local_envir = env)
  state <- getFromNamespace(".state", "escapeR")
  old_player <- state$player
  old_progress <- state$progress
  withr::defer({
    state$player <- old_player
    state$progress <- old_progress
  }, envir = env)
}