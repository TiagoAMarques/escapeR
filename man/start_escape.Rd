\name{start_escape}
\alias{start_escape}
\alias{escape}
\title{Start or Resume an escapeR Game}
\usage{
start_escape(player = NULL, reset = FALSE)

escape(player = NULL, reset = FALSE)
}
\arguments{
\item{player}{Character scalar identifying the player. If omitted interactively, escapeR asks for a name.}
\item{reset}{Logical. If \code{TRUE}, restart the named player's game.}
}
\value{Invisibly returns the current progress list.}
\description{Start a new game or resume saved progress for a returning player.}
