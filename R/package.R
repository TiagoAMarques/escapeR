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
  packageStartupMessage("A virtual ecology lab door is locked. R is the key.")
  packageStartupMessage("Type start_escape() to begin or resume your game.")

  answer <- tryCatch(
    utils::askYesNo("Start or resume an escapeR game now?", default = FALSE),
    error = function(e) FALSE
  )

  if (isTRUE(answer)) {
    start_escape()
  }
}
