## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")

## -----------------------------------------------------------------------------
library(escapeR)

bpmean <- new_room(
  id = "bpmean",
  module = "Medicine",
  title = "The Clinic Intake",
  learning_goal = "Create a numeric vector and calculate its mean.",
  introduction = paste(
    "A clinic intake sheet lists systolic blood pressure readings for",
    "three patients seen before lunch."
  ),
  challenge = paste(
    "Create a vector with the values 120, 124, 111, 182, 130, and 145.",
    "What is the average systolic blood pressure? Submit the mean, rounded to 1 decimal."
  ),
  hints = c(
    "Use c() to combine multiple readings into one vector.",
    "Use mean() to calculate the average of a numeric vector."
  ),
  correct_result = 133.3,
  success = "The intake sheet is complete, and the first cabinet opens.",
  failure = "Not quite, young doctor. Check that all readings are included before taking the mean."
)

riskcat <- new_room(
  id = "riskcat",
  module = "Medicine",
  title = "The Risk Label",
  learning_goal = "Use a logical comparison to classify a value.",
  introduction = paste(
    "A label printer waits beside the triage desk.",
    "It needs the correct risk category for the next patient."
  ),
  challenge = paste(
    "A systolic blood pressure of 145 is considered high if it is above 140.",
    "Submit high or normal."
  ),
  hints = c(
    "Ask R whether 145 > 140.",
    "If the comparison is TRUE, the category requested by the room is high."
  ),
  correct_result = "high",
  success = "The label prints clearly, and the triage desk unlocks."
)

posprop <- new_room(
  id = "posprop",
  module = "Medicine",
  title = "The Test Result Board",
  learning_goal = "Calculate a proportion from counts.",
  introduction = paste(
    "A result board shows 8 positive tests out of 40 tests performed.",
    "The ward door asks for the positive proportion."
  ),
  challenge = "Submit the proportion of tests that were positive.",
  hints = c(
    "A proportion is part divided by whole.",
    "In R, calculate 8 / 40."
  ),
  correct_result = 0.2,
  success = "The board accepts the proportion, and the ward door opens."
)

## -----------------------------------------------------------------------------
medicine_pack <- new_room_pack(
  id = "medpack",
  title = "Introductory medicine rooms",
  description = paste(
    "A small set of medicine-themed rooms for practising vectors,",
    "means, comparisons, and proportions."
  ),
  rooms = list(bpmean, riskcat, posprop),
  escapes = list(
    medmini = c("bpmean", "riskcat"),
    medfull = c("bpmean", "riskcat", "posprop")
  )
)

## -----------------------------------------------------------------------------
register_room_pack(medicine_pack, replace = TRUE)

list_rooms()
list_escapes()

medicine_escape <- build_escape("medfull")
medicine_escape$room_ids

## ----eval = FALSE-------------------------------------------------------------
# escape(player = "demo_medicine", reset = TRUE, escape = medicine_escape)
#
# # Room 1 answer
# submit(133.3)
#
# # Room 2 answer
# submit("high")
#
# # Room 3 answer
# submit(0.2)

## -----------------------------------------------------------------------------
trend <- new_room(
  id = "trend",
  module = "Social sciences",
  title = "The Survey Trend",
  learning_goal = "Interpret a direction of change.",
  introduction = "A survey dashboard compares this year with last year.",
  challenge = "Satisfaction rose from 62 to 70 percent. Submit the direction of change.",
  hints = c(
    "Compare the second value with the first.",
    "Several words can describe an upward change."
  ),
  checker = function(answer) {
    tolower(trimws(as.character(answer))) %in% c("increase", "increased", "up", "rose")
  },
  success = "The dashboard accepts the trend.",
  failure = "Try describing whether the second value is higher or lower than the first."
)

## ----eval = FALSE-------------------------------------------------------------
# medicine_room_pack <- function() {
#   bpmean <- new_room(
#     id = "bpmean",
#     module = "Medicine",
#     title = "The Clinic Intake",
#     learning_goal = "Create a numeric vector and calculate its mean.",
#     introduction = paste(
#       "A clinic intake sheet lists systolic blood pressure readings for",
#     "three patients seen before lunch."
#   ),
#   challenge = paste(
#       "Create a vector with the values 120, 124, 111, 182, 130, and 145.",
#       "What is the average systolic blood pressure? Submit the mean, rounded to 1 decimal."
#   ),
#   hints = c(
#       "Use c() to combine multiple readings into one vector.",
#       "Use mean() to calculate the average of a numeric vector."
#   ),
#     correct_result = 133.3,
#     success = "The intake sheet is complete, and the first cabinet opens.",
#     failure = "Not quite, young doctor. Check that all readings are included before taking the mean."
#   )
# 
#   riskcat <- new_room(
#     id = "riskcat",
#     module = "Medicine",
#     title = "The Risk Label",
#     learning_goal = "Use a logical comparison to classify a value.",
#     introduction = "A label printer waits beside the triage desk.",
#     challenge = paste(
#       "A systolic blood pressure of 145 is considered high if it is above 140.",
#       "Submit high or normal."
#     ),
#     hints = c(
#       "Ask R whether 145 > 140.",
#       "If the comparison is TRUE, the category requested by the room is high."
#     ),
#     correct_result = "high",
#     success = "The label prints clearly, and the triage desk unlocks."
#   )
# 
#   posprop <- new_room(
#     id = "posprop",
#     module = "Medicine",
#     title = "The Test Result Board",
#     learning_goal = "Calculate a proportion from counts.",
#     introduction = paste(
#       "A result board shows 8 positive tests out of 40 tests performed.",
#       "The ward door asks for the positive proportion."
#     ),
#     challenge = "Submit the proportion of tests that were positive.",
#     hints = c(
#       "A proportion is part divided by whole.",
#       "In R, calculate 8 / 40."
#     ),
#     correct_result = 0.2,
#     success = "The board accepts the proportion, and the ward door opens."
#   )
# 
#   new_room_pack(
#     id = "medpack",
#     title = "Introductory medicine rooms",
#     description = paste(
#       "A small set of medicine-themed rooms for practising vectors,",
#       "means, comparisons, and proportions."
#     ),
#     rooms = list(bpmean, riskcat, posprop),
#     escapes = list(
#       medmini = c("bpmean", "riskcat"),
#       medfull = c("bpmean", "riskcat", "posprop")
#     )
#   )
# }

## ----eval = FALSE-------------------------------------------------------------
# test_that("medicine room pack is registered and playable", {
#   expect_true(all(
#     c("bpmean", "riskcat", "posprop") %in% list_rooms()$id
#   ))
#   expect_true(all(c("medmini", "medfull") %in% list_escapes()$id))
# 
#   medicine_escape <- build_escape("medfull")
#   expect_equal(
#     medicine_escape$room_ids,
#     c("bpmean", "riskcat", "posprop")
#   )
# 
#   player <- paste0("medicine_test_", Sys.getpid())
#   escape(player = player, reset = TRUE, escape = medicine_escape)
# 
#   expect_false(submit(100))
#   expect_true(submit(133.3))
#   expect_true(submit(" HIGH "))
#   expect_true(submit(0.2))
# })

## ----eval = FALSE-------------------------------------------------------------
# expect_true(x > 0)             # a condition holds
# expect_false(is.na(x))         # a condition does not hold
# expect_equal(result, 4)        # two values are equal
# expect_error(log("text"))      # an error is triggered
# expect_warning(sqrt(-1))       # a warning is triggered
# expect_type(x, "double")       # typeof(x) is "double"

## ----eval = FALSE-------------------------------------------------------------
# devtools::test()

## ----eval = FALSE-------------------------------------------------------------
# devtools::document()
# devtools::test()
# devtools::check()

## ----eval = FALSE-------------------------------------------------------------
# test_that("a correct answer advances the player", {
#   # Arrange
#   player <- paste0("medicine_test_", Sys.getpid())
#   medicine_escape <- build_escape("medmini")
#   escape(player = player, reset = TRUE, escape = medicine_escape)
# 
#   # Act and assert
#   expect_false(submit(100))
#   expect_true(submit(133.3))
# })

## ----eval = FALSE-------------------------------------------------------------
# expect_equal(
#   medicine_escape$room_ids,
#   c("bpmean", "riskcat", "posprop"),
#   info = "The full medicine escape must preserve its teaching order"
# )

## ----eval = FALSE-------------------------------------------------------------
# expect_error(
#   build_escape("unknown_escape"),
#   regexp = "unknown"
# )

## ----eval = FALSE-------------------------------------------------------------
# expect_equal(calculated_proportion, 0.2, tolerance = 1e-8)

## ----eval = FALSE-------------------------------------------------------------
# devtools::test()

## ----eval = FALSE-------------------------------------------------------------
# testthat::test_file("tests/testthat/test-room-pack-medicine.R")
# testthat::test_dir("tests/testthat")

