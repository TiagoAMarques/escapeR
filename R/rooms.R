.rooms <- function() {
  list(
    list(
      id = 1,
      title = "The Console Door",
      learning_goal = "Use R as a calculator and learn expression order.",
      story = "A keypad blinks beside the first door. It accepts only an R result.",
      task = "Run this in R and submit the result: 6 * 7.",
      hint = "R follows normal arithmetic rules. Multiplication uses *.",
      checker = function(answer) identical(as.numeric(answer), 42),
      success = "The keypad clicks. The console trusts you now."
    ),
    list(
      id = 2,
      title = "The Vector Cabinet",
      learning_goal = "Create vectors and summarize them with functions.",
      story = "Four field notebooks are locked in a cabinet marked counts.",
      task = "Create c(4, 7, 9, 10) and submit its mean.",
      hint = "Try mean(c(4, 7, 9, 10)).",
      checker = function(answer) isTRUE(all.equal(as.numeric(answer), 7.5)),
      success = "The notebooks open, and the first survey numbers are yours."
    ),
    list(
      id = 3,
      title = "The Data Table Hatch",
      learning_goal = "Read and inspect a CSV data set.",
      story = "A hatch asks how many rows are in the tutorial data file.",
      task = "Use escapeR_file('dados1.csv'), read.csv(), and submit nrow() of the data.",
      hint = "d <- read.csv(escapeR_file('dados1.csv')); nrow(d)",
      checker = function(answer) identical(as.integer(answer), 25L),
      success = "Rows become records; records become evidence."
    ),
    list(
      id = 4,
      title = "The Plotting Window",
      learning_goal = "Make a basic plot and read a visual pattern.",
      story = "A window is painted over. It clears only after you draw the detection pattern.",
      task = "Run plot_detection(). How many observations farther than 90 m were detected? Submit that number.",
      hint = "Check the points with distance_m > 90. In the data, TRUE means detected and FALSE means not detected.",
      checker = function(answer) identical(as.integer(answer), 0L),
      success = "The window clears. The transect is visible."
    ),
    list(
      id = 5,
      title = "The Subsetting Lock",
      learning_goal = "Subset data frames using logical conditions.",
      story = "A drawer labelled wetland is locked by a mean count.",
      task = "Using survey_counts(), submit the mean count for habitat == 'wetland'.",
      hint = "d <- survey_counts(); mean(d$count[d$habitat == 'wetland'])",
      checker = function(answer) isTRUE(all.equal(as.numeric(answer), 19)),
      success = "The wetland drawer opens with a soft statistical sigh."
    ),
    list(
      id = 6,
      title = "The Model Room",
      learning_goal = "Fit and interpret a simple linear model.",
      story = "A whiteboard says abundance is never just a number; it is a relationship.",
      task = "Fit lm(count ~ distance_m, data = survey_counts()). Is the distance slope positive or negative? Submit 'negative'.",
      hint = "Look at coef(lm(count ~ distance_m, data = survey_counts())).",
      checker = function(answer) tolower(trimws(as.character(answer))) %in% c("negative", "neg", "-"),
      success = "The model room unlocks. Coefficients are clues, not decorations."
    ),
    list(
      id = 7,
      title = "The Observation Filter",
      learning_goal = "Connect observed data to an imperfect observation process.",
      story = "Two panels appear: state process and observation process. Only one controls what you actually see.",
      task = "In distance sampling, what is the usual detection probability at distance zero? Submit 1.",
      hint = "A core conventional assumption is certain detection on the line or at the point.",
      checker = function(answer) isTRUE(all.equal(as.numeric(answer), 1)),
      success = "The observation filter hums. You have seen the difference between animals and detections."
    ),
    list(
      id = 8,
      title = "The Quarto Exit",
      learning_goal = "Recognize reproducible reports as part of the analysis workflow.",
      story = "The final door asks for the file type that lets code, text, and output travel together.",
      task = "Submit the common Quarto source extension, including the dot.",
      hint = "The tutorial repository uses files like TAMsIntro2RviaRStudioTutorial.qmd.",
      checker = function(answer) identical(tolower(trimws(as.character(answer))), ".qmd"),
      success = "The exit opens. You escaped by making the analysis reproducible."
    )
  )
}

.current_room <- function(progress) {
  rooms <- .rooms()
  if (progress$room > length(rooms)) {
    return(NULL)
  }
  rooms[[progress$room]]
}
