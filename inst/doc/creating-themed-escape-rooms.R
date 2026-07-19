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
    "Create a vector with the values 120, 130, and 140.",
    "What is the average systolic blood pressure? Submit the mean."
  ),
  hints = c(
    "Use c() to combine the three readings into one vector.",
    "Use mean() to calculate the average of a numeric vector."
  ),
  correct_result = 130,
  success = "The intake sheet is complete, and the first cabinet opens.",
  failure = "Not quite. Check that all three readings are included before taking the mean."
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
# submit(130)
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
#       "three patients seen before lunch."
#     ),
#     challenge = paste(
#       "Create a vector with the values 120, 130, and 140.",
#       "What is the average systolic blood pressure? Submit the mean."
#     ),
#     hints = c(
#       "Use c() to combine the three readings into one vector.",
#       "Use mean() to calculate the average of a numeric vector."
#     ),
#     correct_result = 130,
#     success = "The intake sheet is complete, and the first cabinet opens.",
#     failure = "Not quite. Check that all three readings are included before taking the mean."
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
# test_that("medicine room pack can be registered and played", {
#   pack <- medicine_room_pack()
#   register_room_pack(pack, replace = TRUE)
# 
#   expect_true(all(c("bpmean", "riskcat", "posprop") %in% list_rooms()$id))
#   expect_equal(build_escape("medfull")$room_ids, c("bpmean", "riskcat", "posprop"))
#   expect_true(pack$rooms[[1]]$checker(130))
#   expect_true(pack$rooms[[2]]$checker("high"))
#   expect_true(pack$rooms[[3]]$checker(0.2))
# })

