# Author: replace with your name
# Student number: replace with your student number
# Course topic: means of ecological counts
# Data source: invented counts for this teaching example
# Teacher's solution: mean(c(2, 4, 6)) gives 4 snails per quadrat
# Change the example into your own puzzle before submitting it.

library(escapeR)

my_room <- new_room(
  id = "s19549a",
  module = "Ecological summaries",
  title = "The Snail Garden",
  learning_goal = "Create a vector and calculate a mean.",
  introduction = "A garden gate is locked. Three quadrat counts are written on its sign.",
  challenge = "Three equal-area quadrats contain 2, 4, and 6 snails. Use R to calculate the mean number of snails per quadrat. Submit that mean.",
  hints = c(
    "The mean is the sum of the counts divided by the number of quadrats.",
    "Use c() to put the three counts into a vector, then use mean().",
    "Try mean(c(2, 4, 6))."
  ),
  correct_result = 4,
  success = "The gate opens. You can take your field notebook into the garden!",
  failure = "Check that you included all three quadrats, then calculate their mean."
)

# This makes the room available for playing in this R session.
# replace = TRUE lets you source the file again after editing your own room.
register_rooms(my_room, replace = TRUE)
