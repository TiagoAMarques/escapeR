#' escapeR: escape room adventures for learning R
#'
#' Load the package in an interactive R session to enter the room, or call
#' [start_escape()] explicitly.
#'
#' To learn how to create themed rooms or contributor room packs, see the
#' vignette with `vignette("creating-themed-escape-rooms", package = "escapeR")`.
"_PACKAGE"

.onAttach <- function(libname, pkgname) {
  if (!interactive()) {
    return(invisible())
  }

  packageStartupMessage("Welcome to escapeR.")
  packageStartupMessage("A virtual ecological statistics lab door is locked. Unfortunately, you are on the inside! And there are many pressing conservation problems outside you need to start working on. R might just be the key to get started solving them.")
  packageStartupMessage("Run start_escape() to begin or resume your game.")
}
