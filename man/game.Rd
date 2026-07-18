\name{play}
\alias{play}
\alias{submit}
\alias{hint}
\alias{status}
\alias{reset_game}
\alias{list_rooms}
\title{Play the escapeR Game}
\usage{
play()

submit(answer)

hint()

status()

reset_game(player = NULL)

list_rooms()
}
\arguments{
\item{answer}{The answer to check for the current room.}
\item{player}{Character scalar. Defaults to the active player.}
}
\value{\code{play()}, \code{hint()}, \code{status()}, and \code{reset_game()} return useful game objects invisibly. \code{submit()} invisibly returns whether the answer was correct. \code{list_rooms()} returns a data frame with room IDs, modules, titles, and learning goals.}
\description{Functions used by students to move through the virtual escape room.}
