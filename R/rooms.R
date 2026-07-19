.num_equal <- function(answer, target, tolerance = sqrt(.Machine$double.eps)) {
  value <- suppressWarnings(as.numeric(answer))
  isTRUE(all.equal(value, target, tolerance = tolerance))
}

.answer_text <- function(answer) {
  tolower(trimws(as.character(answer)))
}

.room_addons <- new.env(parent = emptyenv())
.escape_addons <- new.env(parent = emptyenv())

#' Create an escapeR room
#'
#' @param id Unique room ID: a word of at most 8 characters.
#' @param module,title,learning_goal,introduction,challenge Character strings
#'   describing the room.
#' @param hints Character vector of hints shown sequentially by `hint()`.
#' @param correct_result Optional expected answer. Numeric and character
#'   results get helpful default checking.
#' @param checker Optional function that takes a submitted answer and returns
#'   `TRUE` for success.
#' @param success Message shown when the room is solved.
#' @param failure Optional message shown when the submitted answer is wrong.
#' @return A modular room object that can be registered with `register_rooms()`.
#' @export
new_room <- function(id, module, title, learning_goal, introduction, challenge,
                     hints, correct_result = NULL, checker = NULL, success,
                     failure = NULL) {
  .room(
    id = id,
    module = module,
    title = title,
    learning_goal = learning_goal,
    introduction = introduction,
    challenge = challenge,
    hints = hints,
    correct_result = correct_result,
    checker = checker,
    success = success,
    failure = failure
  )
}

#' Register contributed rooms
#'
#' @param ... Room objects created by `new_room()`, or a list of room objects.
#' @param replace Logical. If `TRUE`, replace a previously registered room with
#'   the same ID.
#' @return Invisibly returns the registered room IDs.
#' @export
register_rooms <- function(..., replace = FALSE) {
  rooms <- list(...)
  if (length(rooms) == 1L && is.list(rooms[[1]]) && !inherits(rooms[[1]], "escapeR_room")) {
    rooms <- rooms[[1]]
  }
  if (!length(rooms)) {
    stop("Provide at least one room to register.", call. = FALSE)
  }

  ids <- character(length(rooms))
  for (i in seq_along(rooms)) {
    room <- rooms[[i]]
    if (!inherits(room, "escapeR_room")) {
      stop("All registered rooms must be created by new_room().", call. = FALSE)
    }
    id <- room$id
    if (exists(id, envir = .room_addons, inherits = FALSE) && !isTRUE(replace)) {
      stop("Room ID already registered: ", id, call. = FALSE)
    }
    if (id %in% .builtin_room_ids() && !isTRUE(replace)) {
      stop("Room ID is already used by a bundled room: ", id, call. = FALSE)
    }
    assign(id, room, envir = .room_addons)
    ids[[i]] <- id
  }

  invisible(ids)
}

#' Create a shareable room pack
#'
#' @param id Unique pack ID: a word of at most 8 characters.
#' @param title,description Character strings describing the pack.
#' @param rooms A list of room objects created by `new_room()`.
#' @param escapes A named list where each element is a character vector of room
#'   IDs. These are suggested playable room sequences.
#' @return A room pack object that can be registered with `register_room_pack()`.
#' @export
new_room_pack <- function(id, title, description, rooms, escapes) {
  id <- .validate_room_id(id)
  if (!is.list(rooms) || !length(rooms)) {
    stop("`rooms` must be a non-empty list of rooms created by new_room().", call. = FALSE)
  }
  for (room in rooms) {
    if (!inherits(room, "escapeR_room")) {
      stop("Every entry in `rooms` must be created by new_room().", call. = FALSE)
    }
  }
  if (!is.list(escapes) || !length(escapes) || is.null(names(escapes)) || any(!nzchar(names(escapes)))) {
    stop("`escapes` must be a named list of room ID vectors.", call. = FALSE)
  }
  escape_ids <- vapply(names(escapes), .validate_room_id, character(1))
  names(escapes) <- escape_ids
  room_ids <- vapply(rooms, `[[`, character(1), "id")
  for (escape_rooms in escapes) {
    unknown <- setdiff(tolower(as.character(escape_rooms)), room_ids)
    if (length(unknown)) {
      stop("Escape sequences can only use rooms from the same pack. Unknown room ID: ",
           paste(unknown, collapse = ", "), call. = FALSE)
    }
  }

  pack <- list(
    id = id,
    title = .text_scalar(title, "title"),
    description = .text_scalar(description, "description"),
    rooms = rooms,
    escapes = lapply(escapes, function(x) tolower(as.character(x)))
  )
  class(pack) <- c("escapeR_room_pack", "list")
  pack
}

#' Register a room pack
#'
#' @param pack A room pack created by `new_room_pack()`.
#' @param replace Logical. If `TRUE`, replace previously registered rooms or
#'   escape sequences with the same IDs.
#' @return Invisibly returns the pack ID.
#' @export
register_room_pack <- function(pack, replace = FALSE) {
  if (!inherits(pack, "escapeR_room_pack")) {
    stop("`pack` must be created by new_room_pack().", call. = FALSE)
  }
  register_rooms(pack$rooms, replace = replace)
  for (escape_id in names(pack$escapes)) {
    if (exists(escape_id, envir = .escape_addons, inherits = FALSE) && !isTRUE(replace)) {
      stop("Escape ID already registered: ", escape_id, call. = FALSE)
    }
    assign(
      escape_id,
      list(
        id = escape_id,
        pack_id = pack$id,
        room_ids = pack$escapes[[escape_id]]
      ),
      envir = .escape_addons
    )
  }
  invisible(pack$id)
}

.room <- function(id, module, title, learning_goal, introduction, challenge,
                  hints, correct_result = NULL, checker = NULL, success,
                  failure = NULL) {
  id <- .validate_room_id(id)
  if (is.null(checker)) {
    checker <- .result_checker(correct_result)
  }
  if (!is.function(checker)) {
    stop("`checker` must be a function.", call. = FALSE)
  }

  room <- list(
    id = id,
    module = .text_scalar(module, "module"),
    title = .text_scalar(title, "title"),
    learning_goal = .text_scalar(learning_goal, "learning_goal"),
    introduction = .text_scalar(introduction, "introduction"),
    challenge = .text_scalar(challenge, "challenge"),
    hints = as.character(hints),
    correct_result = correct_result,
    checker = checker,
    success = .text_scalar(success, "success"),
    failure = failure
  )

  if (!length(room$hints) || any(!nzchar(room$hints))) {
    stop("`hints` must contain at least one non-empty hint.", call. = FALSE)
  }
  if (!is.null(failure)) {
    room$failure <- .text_scalar(failure, "failure")
  }

  room$story <- room$introduction
  room$task <- room$challenge
  room$hint <- room$hints
  class(room) <- c("escapeR_room", "list")
  room
}

.validate_room_id <- function(id) {
  id <- .text_scalar(id, "id")
  if (!grepl("^[A-Za-z][A-Za-z0-9_]{0,7}$", id)) {
    stop("Room IDs must be words of at most 8 letters, numbers, or underscores, starting with a letter.", call. = FALSE)
  }
  tolower(id)
}

.text_scalar <- function(x, name) {
  if (length(x) != 1L || is.na(x) || !nzchar(trimws(as.character(x)))) {
    stop("`", name, "` must be a single non-empty string.", call. = FALSE)
  }
  as.character(x)
}

.result_checker <- function(correct_result) {
  force(correct_result)
  function(answer) {
    if (is.numeric(correct_result)) {
      .num_equal(answer, correct_result)
    } else if (is.character(correct_result)) {
      identical(.answer_text(answer), .answer_text(correct_result))
    } else {
      identical(answer, correct_result)
    }
  }
}

.builtin_room_ids <- function() {
  c(
    "console", "vector", "finddata", "datatab", "columns", "missing",
    "plotwin", "habitat", "hidden", "subset", "sorting", "model",
    "resid", "predict", "detectp", "detect", "trunc", "comment",
    "quarto"
  )
}

.room_registry <- function() {
  rooms <- .room_definitions()
  addons <- as.list(.room_addons, all.names = TRUE)
  for (addon in addons) {
    ids <- vapply(rooms, `[[`, character(1), "id")
    existing <- match(addon$id, ids)
    if (is.na(existing)) {
      rooms <- c(rooms, list(addon))
    } else {
      rooms[[existing]] <- addon
    }
  }
  ids <- vapply(rooms, `[[`, character(1), "id")
  if (anyDuplicated(ids)) {
    stop("Room IDs must be unique.", call. = FALSE)
  }
  stats::setNames(rooms, ids)
}

.rooms <- function(ids = NULL) {
  registry <- .room_registry()
  if (is.null(ids)) {
    ids <- .builtin_room_ids()
  }
  ids <- tolower(as.character(ids))
  missing <- setdiff(ids, names(registry))
  if (length(missing)) {
    stop("Unknown room ID: ", paste(missing, collapse = ", "), call. = FALSE)
  }
  unname(registry[ids])
}

#' Build a custom escape room sequence
#'
#' @param rooms Character vector of room IDs. Use `list_rooms()` to see the
#'   bundled rooms that can be combined.
#' @return An escape sequence object that can be passed to `escape()`.
#' @export
build_escape <- function(rooms = .builtin_room_ids()) {
  if (length(rooms) == 1L && exists(tolower(rooms), envir = .escape_addons, inherits = FALSE)) {
    rooms <- get(tolower(rooms), envir = .escape_addons, inherits = FALSE)$room_ids
  }
  selected <- .rooms(rooms)
  structure(
    list(
      rooms = selected,
      room_ids = vapply(selected, `[[`, character(1), "id")
    ),
    class = "escapeR_escape"
  )
}

.escape_ids <- function(escape = NULL) {
  if (is.null(escape)) {
    return(.builtin_room_ids())
  }
  if (inherits(escape, "escapeR_escape")) {
    return(escape$room_ids)
  }
  if (is.character(escape)) {
    return(build_escape(escape)$room_ids)
  }
  stop("`escape` must be created by build_escape() or be a character vector of room IDs.", call. = FALSE)
}

#' List registered escape sequences
#'
#' @return A data frame with available registered escape sequences.
#' @export
list_escapes <- function() {
  escapes <- as.list(.escape_addons, all.names = TRUE)
  if (!length(escapes)) {
    return(data.frame(
      id = character(),
      pack_id = character(),
      rooms = character(),
      stringsAsFactors = FALSE
    ))
  }
  data.frame(
    id = vapply(escapes, `[[`, character(1), "id"),
    pack_id = vapply(escapes, `[[`, character(1), "pack_id"),
    rooms = vapply(escapes, function(x) paste(x$room_ids, collapse = ", "), character(1)),
    stringsAsFactors = FALSE
  )
}

.room_definitions <- function() {
  list(
    .room(
      id = "console",
      module = "R foundations",
      title = "The Console Door",
      learning_goal = "Use R as a calculator and learn expression order.",
      introduction = "A keypad blinks beside the first door. It accepts only an R result.",
      challenge = "The pad code is the weight, in grams, of 10 individuals of species A and 8 animals of species B, each of them weighing exactly 3 grams and 5 grams, respectively.",
      hints = "R follows normal arithmetic rules. Multiplication uses *.",
      correct_result = 70,
      success = "The keypad clicks. The console trusts you now."
    ),
    .room(
      id = "vector",
      module = "R foundations",
      title = "The Vector Cabinet",
      learning_goal = "Create vectors and summarize them with functions.",
      introduction = "Four field notebooks are locked in a cabinet marked counts.",
      challenge = "Create a vector with the numbers 1, 5, 9, 13, 17, 21, 25, 29, pretending those are the number of parasites in 8 different fishes collected in a river. What is the average number of parasites per fish? Submit that average value.",
      hints = c(
        "Use c() to combine individual values into a vector.",
        "Those numbers form a regular sequence, so seq(1, 29, 4) can create the same vector."
      ),
      correct_result = 15,
      success = "The notebooks open, and the first survey numbers are yours."
    ),
    .room(
      id = "finddata",
      module = "Data import and inspection",
      title = "Finding Data",
      learning_goal = "Find and inspect built-in R datasets.",
      introduction = "A catalogue of built-in data sets waits on a reading desk.",
      challenge = "In the package Datasets there's a dataset that reminds one of candy. It has 84 rows. How much did seed 331 grew between ages 5 and 10 years? Based on that information, how much did that plant grow per year during that period, rounded to two decimal places? That is the number you need to use to open the lock.",
      hints = c(
        "You can inspect a dataset by using library(help = \"datasets\")",
        "lolly is a candy :) "
      ),
      correct_result = 3.36,
      success = "The catalogue opens. Finding data is often the first real step of analysis."
    ),
    .room(
      id = "datatab",
      module = "Data import and inspection",
      title = "The Data Table Hatch",
      learning_goal = "Read and inspect a CSV data set.",
      introduction = "A hatch asks how many rows are in the tutorial data file.",
      challenge = "Use escapeR_file('dados1.csv'), read.csv(), and submit the number of rows in the data.",
      hints = "Read the file first, then ask the data frame how many rows it has.",
      checker = function(answer) identical(as.integer(answer), 25L),
      success = "Rows become records; records become evidence."
    ),
    .room(
      id = "columns",
      module = "Data import and inspection",
      title = "The Column Scanner",
      learning_goal = "Identify variables in a data frame.",
      introduction = "A scanner sweeps across the data table and asks for the name of the last column.",
      challenge = "Read the tutorial data with read.csv(escapeR_file('dados1.csv')). Submit the name of its last column.",
      hints = "names() shows column names. tail() can show the last part of many R objects.",
      correct_result = "x3",
      success = "The scanner beeps approvingly. Column names are not decoration; they are the map."
    ),
    .room(
      id = "missing",
      module = "Data import and inspection",
      title = "The Missing Value Mirror",
      learning_goal = "Check data quality before analysis.",
      introduction = "A mirror shows a table, but only missing values cast shadows.",
      challenge = "Using survey_counts(), submit the number of missing values in the whole data set.",
      hints = "is.na() finds missing values. sum() can count TRUE values.",
      checker = function(answer) identical(as.integer(answer), 2L),
      success = "Two shadows found. Missing values are not embarrassing; pretending they are not there is."
    ),
    .room(
      id = "plotwin",
      module = "Visualisation",
      title = "The Plotting Window",
      learning_goal = "Make a basic plot and read a visual pattern.",
      introduction = "A window is painted over. It clears only after you draw the detection pattern.",
      challenge = "Using survey_counts(), represent how detection varies with distance_m. Look at the plot: how many observations farther than 90 m were detected? Submit that number.",
      hints = "Try plot(d$distance_m, jitter(as.integer(d$detected))). jitter() helps you see whether many points share the same coordinate.",
      checker = function(answer) identical(as.integer(answer), 2L),
      success = "The window clears. The transect is visible."
    ),
    .room(
      id = "habitat",
      module = "Visualisation",
      title = "The Habitat Mosaic",
      learning_goal = "Use tables to summarize categorical variables before plotting.",
      introduction = "Tiles on the floor rearrange themselves into habitat names.",
      challenge = "Using survey_counts(), count how many records belong to each habitat. Submit the count for scrub.",
      hints = "table(d$habitat) is a compact way to count categories in a column.",
      checker = function(answer) identical(as.integer(answer), 6L),
      success = "The mosaic settles. Every plot gets easier when the data have first been counted."
    ),
    .room(
      id = "hidden",
      module = "Visualisation",
      title = "The Hidden Data",
      learning_goal = "Discover that plotted data can reveal structure hidden in plain text.",
      introduction = "A file sits on the bench, ordinary at first glance but quietly insistent.",
      challenge = "Data can sometimes contain more of something than what meets the eye at first. Can you find in the data hidden in escapeR_file('datahide.txt') what it is that data might contain hidden?",
      hints = "You must plot the data in just the right way!",
      correct_result = "information",
      failure = "That is not the information we are looking for; please try again!",
      success = "The plotted points settle into meaning. Some data keep their secrets until you ask visually."
    ),
    .room(
      id = "subset",
      module = "Data manipulation",
      title = "The Subsetting Lock",
      learning_goal = "Subset data frames using logical conditions.",
      introduction = "A drawer labelled wetland is locked by a mean count.",
      challenge = "Using survey_counts(), submit the mean count for the wetland records.",
      hints = "Use a logical condition inside square brackets to keep one habitat before taking the mean. If missing values appear, mean() has an argument that can remove them.",
      correct_result = 19.5,
      success = "The wetland drawer opens with a soft statistical sigh."
    ),
    .room(
      id = "sorting",
      module = "Data manipulation",
      title = "The Sorting Staircase",
      learning_goal = "Order data and inspect extreme observations.",
      introduction = "A staircase sorts itself by distance, but one step is still blank.",
      challenge = "Using survey_counts(), find the site with the largest distance_m. Submit its site code.",
      hints = "which.max() returns the position of the largest value in a vector.",
      correct_result = "s18",
      success = "The staircase locks into order. Extremes often deserve a second look."
    ),
    .room(
      id = "model",
      module = "Ecological modelling",
      title = "The Model Room",
      learning_goal = "Fit and interpret a simple linear model.",
      introduction = "A whiteboard says abundance is never just a number; it is a relationship.",
      challenge = "Fit lm(count ~ distance_m, data = survey_counts()). Look at the distance_m coefficient. Is it above or below zero?",
      hints = "coef() gives model coefficients. The coefficient named distance_m describes the slope.",
      checker = function(answer) .answer_text(answer) %in% c("below", "below zero", "negative", "neg", "-"),
      success = "The model room unlocks. Coefficients are clues, not decorations."
    ),
    .room(
      id = "resid",
      module = "Ecological modelling",
      title = "The Residual Drawer",
      learning_goal = "Understand that fitted models leave residual variation.",
      introduction = "A drawer rattles with the bits of data the model did not explain.",
      challenge = "Fit lm(count ~ distance_m, data = survey_counts()). How many residuals does the model have?",
      hints = "residuals(model) returns one residual for each observation used to fit the model.",
      checker = function(answer) identical(as.integer(answer), 18L),
      success = "The drawer quiets. Residuals are not failure; they are the part still asking questions."
    ),
    .room(
      id = "predict",
      module = "Ecological modelling",
      title = "The Prediction Lantern",
      learning_goal = "Use a fitted model to predict for a new ecological setting.",
      introduction = "A lantern asks what the model expects at a distance not written in the field notebook.",
      challenge = "Fit lm(count ~ distance_m, data = survey_counts()). Predict count at distance_m = 50 and submit the value rounded to one decimal place.",
      hints = "predict() needs a data frame with a column named exactly like the model predictor.",
      checker = function(answer) .num_equal(answer, 13.9, tolerance = 1e-8),
      success = "The lantern glows. Prediction is interpolation with assumptions attached."
    ),
    .room(
      id = "detectp",
      module = "Distance sampling",
      title = "The Observation Filter",
      learning_goal = "Connect observed data to an imperfect observation process.",
      introduction = "Two panels appear: state process and observation process. Only one controls what you actually see.",
      challenge = "In conventional distance sampling, objects exactly on the line or at the point are assumed to be detected with certainty. What detection probability does 'certainty' correspond to?",
      hints = "A probability scale runs from impossible to certain.",
      correct_result = 1,
      success = "The observation filter hums. You have seen the difference between animals and detections."
    ),
    .room(
      id = "detect",
      module = "Distance sampling",
      title = "The Detection Counter",
      learning_goal = "Summarize detections as observed outcomes.",
      introduction = "The transect logbook asks how many animals were actually seen.",
      challenge = "Using survey_counts(), submit the total number of detected records.",
      hints = "The detected column is logical, and R treats TRUE as 1 and FALSE as 0 when summed.",
      checker = function(answer) identical(as.integer(answer), 13L),
      success = "The logbook closes. Counts of detections are observations, not yet abundance."
    ),
    .room(
      id = "trunc",
      module = "Distance sampling",
      title = "The Truncation Gate",
      learning_goal = "Think about distance cutoffs and retained observations.",
      introduction = "A gate marked 100 m asks how many records would remain inside it.",
      challenge = "Using survey_counts(), count records with distance_m <= 100. Submit that count.",
      hints = "A logical comparison can be counted with sum().",
      checker = function(answer) identical(as.integer(answer), 14L),
      success = "The gate swings open. Truncation is a modelling choice, not a clerical detail."
    ),
    .room(
      id = "comment",
      module = "Reproducible workflow",
      title = "The Comment Cipher",
      learning_goal = "Recognize comments as part of readable R code.",
      introduction = "A script is covered in notes to future-you, which is honestly a kindness.",
      challenge = "What character starts a comment in R code?",
      hints = "It is also called a hash or number sign.",
      correct_result = "#",
      success = "The cipher accepts the mark. Good comments explain why the code exists."
    ),
    .room(
      id = "quarto",
      module = "Reproducible workflow",
      title = "The Quarto Exit",
      learning_goal = "Recognize reproducible reports as part of the analysis workflow.",
      introduction = "The final door asks for the file type that lets code, text, and output travel together.",
      challenge = "Submit the common Quarto source file extension, including the dot.",
      hints = "The tutorial repository uses files whose names end with this extension.",
      correct_result = ".qmd",
      success = "The exit opens. You escaped by making the analysis reproducible."
    )
  )
}

.current_room <- function(progress) {
  rooms <- .rooms(progress$escape_ids)
  if (progress$room > length(rooms)) {
    return(NULL)
  }
  rooms[[progress$room]]
}

.failure_message <- function(room) {
  if (!is.null(room$failure)) {
    return(room$failure)
  }

  messages <- c(
    "Not yet. Ecology is full of noisy observations; R lets us be patiently wrong until the pattern becomes clearer.",
    "The lock remains unconvinced. That is fine: statistical thinking is mostly careful iteration with better bookkeeping.",
    "Close enough to be interesting, not close enough to open the door. Try checking the object names and the shape of your data.",
    "A noble attempt. R is annoyingly literal, which is also why it is so useful when field notes become evidence.",
    "The door declines, politely. In ecology, a failed first model is often just the start of understanding the system.",
    "Still locked. Ask R what it has stored so far; names(), str(), head(), and summary() are excellent field assistants."
  )

  index <- match(room$id, .builtin_room_ids())
  if (is.na(index)) {
    index <- 1L
  }
  index <- ((index - 1L) %% length(messages)) + 1L
  messages[[index]]
}
