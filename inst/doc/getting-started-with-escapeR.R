## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>")
library(escapeR)

## ----eval = FALSE-------------------------------------------------------------
# library(escapeR)
# escape()

## ----eval = FALSE-------------------------------------------------------------
# escape(player = "ana")

## ----eval = FALSE-------------------------------------------------------------
# submit(70)

## ----eval = FALSE-------------------------------------------------------------
# submit("negative")
# submit(".qmd")

## ----eval = FALSE-------------------------------------------------------------
# hint()

## ----eval = FALSE-------------------------------------------------------------
# hint()
# hint()

## ----eval = FALSE-------------------------------------------------------------
# play()

## ----eval = FALSE-------------------------------------------------------------
# status()

## ----eval = FALSE-------------------------------------------------------------
# library(escapeR)
# escape(player = "ana")

## ----eval = FALSE-------------------------------------------------------------
# reset_game()

## ----eval = FALSE-------------------------------------------------------------
# reset_game(player = "ana")

## ----eval = FALSE-------------------------------------------------------------
# escape(player = "ana", reset = TRUE)

## ----eval=FALSE---------------------------------------------------------------
# escapeR_file("dataX.csv")

## ----eval = FALSE-------------------------------------------------------------
# d <- read.csv(escapeR_file("dataX.csv"))
# head(d)

## -----------------------------------------------------------------------------
survey <- survey_counts()
names(survey)
head(survey)
sum(is.na(survey))

## -----------------------------------------------------------------------------
list_rooms()

## ----eval = FALSE-------------------------------------------------------------
# short_quest <- build_escape(c("console", "vector", "plotwin"))
# escape(player = "demo_short", reset = TRUE, escape = short_quest)

## -----------------------------------------------------------------------------
list_escapes()

## ----eval = FALSE-------------------------------------------------------------
# escape()       # start or resume a quest
# play()         # show the current room again
# hint()         # request the next hint
# submit(70)     # submit an answer
# status()       # check progress
# reset_game()   # restart the active quest
# list_rooms()   # inspect available rooms

