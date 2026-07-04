.num_equal <- function(answer, target, tolerance = sqrt(.Machine$double.eps)) {
  value <- suppressWarnings(as.numeric(answer))
  isTRUE(all.equal(value, target, tolerance = tolerance))
}

.answer_text <- function(answer) {
  tolower(trimws(as.character(answer)))
}

.rooms <- function() {
  list(
    list(
      id = 1,
      module = "R foundations",
      title = "The Console Door",
      learning_goal = "Use R as a calculator and learn expression order.",
      story = "A keypad blinks beside the first door. It accepts only an R result.",
      task = "Run this in R and submit the result: 6 * 7.",
      hint = "R follows normal arithmetic rules. Multiplication uses *.",
      checker = function(answer) .num_equal(answer, 42),
      success = "The keypad clicks. The console trusts you now."
    ),
    list(
      id = 2,
      module = "R foundations",
      title = "The Vector Cabinet",
      learning_goal = "Create vectors and summarize them with functions.",
      story = "Four field notebooks are locked in a cabinet marked counts.",
      task = "Create the vector c(4, 7, 9, 10). Submit its average value.",
      hint = "The function you want has the same name as the ordinary statistical average.",
      checker = function(answer) .num_equal(answer, 7.5),
      success = "The notebooks open, and the first survey numbers are yours."
    ),
    list(
      id = 3,
      module = "R foundations",
      title = "The Naming Shelf",
      learning_goal = "Store values in objects and inspect them later.",
      story = "A shelf of labelled jars refuses to move until one jar has the right label.",
      task = "Store c(3, 1, 4, 1, 5) in an object named pi_digits. Submit the third value in that object.",
      hint = "Square brackets extract positions from a vector, as in object_name[position].",
      checker = function(answer) .num_equal(answer, 4),
      success = "The shelf slides away. Named objects make R remember things so you do not have to."
    ),
    list(
      id = 4,
      module = "Data import and inspection",
      title = "The Data Table Hatch",
      learning_goal = "Read and inspect a CSV data set.",
      story = "A hatch asks how many rows are in the tutorial data file.",
      task = "Use escapeR_file('dados1.csv'), read.csv(), and submit the number of rows in the data.",
      hint = "Read the file first, then ask the data frame how many rows it has.",
      checker = function(answer) identical(as.integer(answer), 25L),
      success = "Rows become records; records become evidence."
    ),
    list(
      id = 5,
      module = "Data import and inspection",
      title = "The Column Scanner",
      learning_goal = "Identify variables in a data frame.",
      story = "A scanner sweeps across the data table and asks for the name of the last column.",
      task = "Read the tutorial data with read.csv(escapeR_file('dados1.csv')). Submit the name of its last column.",
      hint = "names() shows column names. tail() can show the last part of many R objects.",
      checker = function(answer) identical(.answer_text(answer), "x3"),
      success = "The scanner beeps approvingly. Column names are not decoration; they are the map."
    ),
    list(
      id = 6,
      module = "Data import and inspection",
      title = "The Missing Value Mirror",
      learning_goal = "Check data quality before analysis.",
      story = "A mirror shows a table, but only missing values cast shadows.",
      task = "Using survey_counts(), submit the number of missing values in the whole data set.",
      hint = "is.na() finds missing values. sum() can count TRUE values.",
      checker = function(answer) identical(as.integer(answer), 2L),
      success = "Two shadows found. Missing values are not embarrassing; pretending they are not there is."
    ),
    list(
      id = 7,
      module = "Visualisation",
      title = "The Plotting Window",
      learning_goal = "Make a basic plot and read a visual pattern.",
      story = "A window is painted over. It clears only after you draw the detection pattern.",
      task = "Run plot_detection(). How many observations farther than 90 m were detected? Submit that number.",
      hint = "Check the points with distance_m > 90. In the data, TRUE means detected and FALSE means not detected.",
      checker = function(answer) identical(as.integer(answer), 0L),
      success = "The window clears. The transect is visible."
    ),
    list(
      id = 8,
      module = "Visualisation",
      title = "The Habitat Mosaic",
      learning_goal = "Use tables to summarize categorical variables before plotting.",
      story = "Tiles on the floor rearrange themselves into habitat names.",
      task = "Using survey_counts(), count how many records belong to each habitat. Submit the count for scrub.",
      hint = "table(d$habitat) is a compact way to count categories in a column.",
      checker = function(answer) identical(as.integer(answer), 4L),
      success = "The mosaic settles. Every plot gets easier when the data have first been counted."
    ),
    list(
      id = 9,
      module = "Data manipulation",
      title = "The Subsetting Lock",
      learning_goal = "Subset data frames using logical conditions.",
      story = "A drawer labelled wetland is locked by a mean count.",
      task = "Using survey_counts(), submit the mean count for the wetland records.",
      hint = "Use a logical condition inside square brackets to keep one habitat before taking the mean. If missing values appear, mean() has an argument that can remove them.",
      checker = function(answer) .num_equal(answer, 19),
      success = "The wetland drawer opens with a soft statistical sigh."
    ),
    list(
      id = 10,
      module = "Data manipulation",
      title = "The Sorting Staircase",
      learning_goal = "Order data and inspect extreme observations.",
      story = "A staircase sorts itself by distance, but one step is still blank.",
      task = "Using survey_counts(), find the site with the largest distance_m. Submit its site code.",
      hint = "which.max() returns the position of the largest value in a vector.",
      checker = function(answer) identical(.answer_text(answer), "s12"),
      success = "The staircase locks into order. Extremes often deserve a second look."
    ),
    list(
      id = 11,
      module = "Ecological modelling",
      title = "The Model Room",
      learning_goal = "Fit and interpret a simple linear model.",
      story = "A whiteboard says abundance is never just a number; it is a relationship.",
      task = "Fit lm(count ~ distance_m, data = survey_counts()). Look at the distance_m coefficient. Is it above or below zero?",
      hint = "coef() gives model coefficients. The coefficient named distance_m describes the slope.",
      checker = function(answer) .answer_text(answer) %in% c("below", "below zero", "negative", "neg", "-"),
      success = "The model room unlocks. Coefficients are clues, not decorations."
    ),
    list(
      id = 12,
      module = "Ecological modelling",
      title = "The Residual Drawer",
      learning_goal = "Understand that fitted models leave residual variation.",
      story = "A drawer rattles with the bits of data the model did not explain.",
      task = "Fit lm(count ~ distance_m, data = survey_counts()). How many residuals does the model have?",
      hint = "residuals(model) returns one residual for each observation used to fit the model.",
      checker = function(answer) identical(as.integer(answer), 12L),
      success = "The drawer quiets. Residuals are not failure; they are the part still asking questions."
    ),
    list(
      id = 13,
      module = "Ecological modelling",
      title = "The Prediction Lantern",
      learning_goal = "Use a fitted model to predict for a new ecological setting.",
      story = "A lantern asks what the model expects at a distance not written in the field notebook.",
      task = "Fit lm(count ~ distance_m, data = survey_counts()). Predict count at distance_m = 50 and submit the value rounded to one decimal place.",
      hint = "predict() needs a data frame with a column named exactly like the model predictor.",
      checker = function(answer) .num_equal(answer, 13.2, tolerance = 1e-8),
      success = "The lantern glows. Prediction is interpolation with assumptions attached."
    ),
    list(
      id = 14,
      module = "Distance sampling",
      title = "The Observation Filter",
      learning_goal = "Connect observed data to an imperfect observation process.",
      story = "Two panels appear: state process and observation process. Only one controls what you actually see.",
      task = "In conventional distance sampling, objects exactly on the line or at the point are assumed to be detected with certainty. What detection probability does 'certainty' correspond to?",
      hint = "A probability scale runs from impossible to certain.",
      checker = function(answer) .num_equal(answer, 1),
      success = "The observation filter hums. You have seen the difference between animals and detections."
    ),
    list(
      id = 15,
      module = "Distance sampling",
      title = "The Detection Counter",
      learning_goal = "Summarize detections as observed outcomes.",
      story = "The transect logbook asks how many animals were actually seen.",
      task = "Using survey_counts(), submit the total number of detected records.",
      hint = "The detected column is logical, and R treats TRUE as 1 and FALSE as 0 when summed.",
      checker = function(answer) identical(as.integer(answer), 9L),
      success = "The logbook closes. Counts of detections are observations, not yet abundance."
    ),
    list(
      id = 16,
      module = "Distance sampling",
      title = "The Truncation Gate",
      learning_goal = "Think about distance cutoffs and retained observations.",
      story = "A gate marked 100 m asks how many records would remain inside it.",
      task = "Using survey_counts(), count records with distance_m <= 100. Submit that count.",
      hint = "A logical comparison can be counted with sum().",
      checker = function(answer) identical(as.integer(answer), 12L),
      success = "The gate swings open. Truncation is a modelling choice, not a clerical detail."
    ),
    list(
      id = 17,
      module = "Reproducible workflow",
      title = "The Comment Cipher",
      learning_goal = "Recognize comments as part of readable R code.",
      story = "A script is covered in notes to future-you, which is honestly a kindness.",
      task = "What character starts a comment in R code?",
      hint = "It is also called a hash or number sign.",
      checker = function(answer) identical(trimws(as.character(answer)), "#"),
      success = "The cipher accepts the mark. Good comments explain why the code exists."
    ),
    list(
      id = 18,
      module = "Reproducible workflow",
      title = "The Quarto Exit",
      learning_goal = "Recognize reproducible reports as part of the analysis workflow.",
      story = "The final door asks for the file type that lets code, text, and output travel together.",
      task = "Submit the common Quarto source file extension, including the dot.",
      hint = "The tutorial repository uses files whose names end with this extension.",
      checker = function(answer) identical(.answer_text(answer), ".qmd"),
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

.failure_message <- function(room) {
  messages <- c(
    "Not yet. Ecology is full of noisy observations; R lets us be patiently wrong until the pattern becomes clearer.",
    "The lock remains unconvinced. That is fine: statistical thinking is mostly careful iteration with better bookkeeping.",
    "Close enough to be interesting, not close enough to open the door. Try checking the object names and the shape of your data.",
    "A noble attempt. R is annoyingly literal, which is also why it is so useful when field notes become evidence.",
    "The door declines, politely. In ecology, a failed first model is often just the start of understanding the system.",
    "Still locked. Ask R what it has stored so far; names(), str(), head(), and summary() are excellent field assistants."
  )

  index <- ((room$id - 1L) %% length(messages)) + 1L
  messages[[index]]
}
