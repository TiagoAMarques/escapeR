#' Find a bundled escapeR example file
#'
#' @param filename Name of a file in `inst/extdata`.
#' @return Full path to the requested file.
escapeR_file <- function(filename) {
  path <- system.file("extdata", filename, package = "escapeR")
  if (!nzchar(path)) {
    stop("Could not find bundled file: ", filename, call. = FALSE)
  }
  path
}

#' Return the small survey data set used in the game
#'
#' @return A data frame with site, habitat, count, distance, and detection fields.
survey_counts <- function() {
  .survey_counts()
}
