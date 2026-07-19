\name{escape}
\alias{escape}
\title{Start or Resume an escapeR Game}
\usage{
escape(player = NULL, reset = FALSE, escape = NULL)
}
\arguments{
\item{player}{Character scalar identifying the player. If omitted interactively, escapeR asks for a name.}
\item{reset}{Logical. If \code{TRUE}, restart the named player's game.}
\item{escape}{Escape sequence created by \code{build_escape()}, or a character vector of room IDs. Defaults to the bundled room sequence.}
}
\value{Invisibly returns the current progress list.}
\description{Start a new game or resume saved progress for a returning player.}
