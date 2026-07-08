#' escapeR: escape room adventures for learning R
#'
#' Load the package in an interactive R session to enter the room, or call
#' [start_escape()] explicitly.
"_PACKAGE"

.onAttach <- function(libname, pkgname) {
  if (!interactive()) {
    return(invisible())
  }

  packageStartupMessage("Welcome to escapeR.")
  packageStartupMessage("A virtual ecological statistics lab door is locked. Unfortunately, you are on the inside! And there are many pressing conservation problems outside you need to start working on. R might just be the key to get started solving them.")
  packageStartupMessage("Type start_escape() to begin or resume your game.")

  answer <- tryCatch(
    utils::askYesNo("Start or resume an escapeR game now?", default = FALSE),
    error = function(e) FALSE
  )

  if (isTRUE(answer)) {
    start_escape()
  }
}
