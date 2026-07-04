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

#' Plot detection against distance
#'
#' @return Invisibly returns the plotted data.
plot_detection <- function() {
  d <- survey_counts()
  old <- par(no.readonly = TRUE)
  on.exit(par(old), add = TRUE)
  plot(
    d$distance_m,
    as.integer(d$detected),
    xlab = "Distance from transect (m)",
    ylab = "Detected",
    yaxt = "n",
    pch = 19,
    col = ifelse(d$detected, "#0072B2", "#D55E00"),
    main = "Detection is an observation process"
  )
  axis(2, at = c(0, 1), labels = c("no", "yes"))
  invisible(d)
}
