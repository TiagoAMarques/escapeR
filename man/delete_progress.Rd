\name{delete_progress}
\alias{delete_progress}
\title{Delete a Saved Player Profile}
\usage{delete_progress(player = .state$player)}
\arguments{\item{player}{Single non-empty player name. Defaults to the active player.}}
\value{Invisibly returns whether a saved file was removed.}
\description{Removes a saved profile and closes the active game if it uses that profile.}
\details{Progress is stored in the per-user directory returned by \code{tools::R_user_dir()}. Set \code{options(escapeR.progress_dir = path)} to select another directory. Delete profiles when no longer needed. Player filenames are case-insensitive and punctuation is replaced by underscores.}
\examples{
local({
  path <- tempfile("escapeR-demo-")
  old <- options(escapeR.progress_dir = path)
  on.exit(options(old))
  on.exit(unlink(path, recursive = TRUE), add = TRUE)
  escape(player = "demo", reset = TRUE)
  submit(70)
  delete_progress("demo")
})
}