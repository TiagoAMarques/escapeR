.survey_counts <- function() {
  data.frame(
    site = paste0("S", 1:14),
    habitat = c(rep(c("forest", "scrub", "wetland"), each = 4), "forest", "wetland"),
    count = c(12, 15, 11, 14, 6, 9, 7, 8, 18, 21, 17, 20, NA, NA),
    distance_m = c(15, 40, 70, 95, 20, 55, 80, 110, 10, 35, 65, 120, 45, 85),
    detected = c(TRUE, TRUE, TRUE, FALSE, TRUE, TRUE, FALSE, FALSE, TRUE, TRUE, TRUE, FALSE, TRUE, FALSE),
    stringsAsFactors = FALSE
  )
}

.detection_plot_data <- function() {
  distance_m <- c(
    5, 8, 12, 15, 18, 22, 25, 28,
    31, 35, 38, 42, 45, 48, 52, 55,
    58, 62, 65, 68, 72, 75, 78, 82,
    85, 88, 92, 95, 98, 102, 106, 110,
    115, 120, 126, 132
  )
  detected <- c(
    TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE,
    TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE,
    TRUE, FALSE, TRUE, TRUE, FALSE, TRUE, FALSE, FALSE,
    TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
    FALSE, FALSE, FALSE, FALSE
  )
  jitter_y <- c(
    -0.06, 0.05, -0.02, 0.03, -0.04, 0.06, -0.01, 0.04,
    -0.05, 0.02, 0.05, -0.03, 0.01, -0.06, 0.04, -0.02,
    0.06, -0.04, 0.03, -0.01, 0.05, -0.05, 0.02, -0.03,
    0.04, -0.02, 0.03, -0.05, 0.01, -0.03, 0.04, -0.01,
    0.05, -0.04, 0.02, -0.06
  )

  data.frame(
    distance_m = distance_m,
    detected = detected,
    plot_y = as.integer(detected) + jitter_y,
    stringsAsFactors = FALSE
  )
}

.tutorial_data <- function() {
  data.frame(
    ID = 1:25,
    x1 = c(3, 2, 4, 5, 2, 3, 4, 5, 2, 3, 42, 43, 2, 43, 6, 4, 3, 234, 34, 4, 243, 24, 2, 2, 2),
    x2 = c(2.1, -5.6, 13.3, -21, -28.7, 36.4, -44.1, 51.8, -5.6, -13.3, -21, -44.1, 51.8, 147.7, 2.1, -5.6, 13.3, -63.35, 0, -145.53, 23, -13, -268.8, 4, -350.98),
    x3 = c(0.7, -2.8, 3.325, -4.2, -14.35, 5.9, -11.025, -2.1, -2.8, 5.7, -0.5, -1.025581395, 25.9, 3.434883721, 4, -1.4, 4.433333333, -0.270726496, 3, -36.3825, 0.094650206, 0.4, -134.4, 2, -175.49)
  )
}

.write_extdata <- function() {
  dir <- system.file("extdata", package = "escapeR")
  if (!nzchar(dir)) {
    return(invisible(FALSE))
  }
  utils::write.csv(.survey_counts(), file.path(dir, "survey_counts.csv"), row.names = FALSE)
  utils::write.csv(.detection_plot_data(), file.path(dir, "detection_plot_data.csv"), row.names = FALSE)
  utils::write.csv(.tutorial_data(), file.path(dir, "dados1.csv"), row.names = FALSE)
  invisible(TRUE)
}
