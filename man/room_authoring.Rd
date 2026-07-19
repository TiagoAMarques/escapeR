\name{build_escape}
\alias{build_escape}
\alias{list_escapes}
\alias{new_room}
\alias{new_room_pack}
\alias{register_room_pack}
\alias{register_rooms}
\title{Build and Register escapeR Rooms}
\usage{
build_escape(rooms = .builtin_room_ids())

list_escapes()

new_room(id, module, title, learning_goal, introduction, challenge,
  hints, correct_result = NULL, checker = NULL, success, failure = NULL)

new_room_pack(id, title, description, rooms, escapes)

register_room_pack(pack, replace = FALSE)

register_rooms(..., replace = FALSE)
}
\arguments{
\item{rooms}{Character vector of room IDs for \code{build_escape()}, or a list of room objects for \code{new_room_pack()}. Use \code{list_rooms()} to see bundled and registered rooms.}
\item{id}{Unique room ID: a word of at most 8 characters.}
\item{module, title, learning_goal, introduction, challenge}{Character strings describing the room.}
\item{description}{Character string describing a room pack.}
\item{hints}{Character vector of hints shown sequentially by \code{hint()}.}
\item{correct_result}{Optional expected answer. Numeric and character results get helpful default checking.}
\item{checker}{Optional function that takes a submitted answer and returns \code{TRUE} for success.}
\item{success}{Message shown when the room is solved.}
\item{failure}{Optional message shown when the submitted answer is wrong.}
\item{escapes}{Named list where each element is a character vector of room IDs.}
\item{pack}{Room pack created by \code{new_room_pack()}.}
\item{...}{Room objects created by \code{new_room()}, or a list of room objects.}
\item{replace}{Logical. If \code{TRUE}, replace a previously registered room with the same ID.}
}
\value{\code{build_escape()} returns an escape sequence object for \code{escape()}. \code{list_escapes()} returns a data frame of registered sequences. \code{new_room()} returns a modular room object. \code{new_room_pack()} returns a shareable room pack. Registration helpers return IDs invisibly.}
\description{Helpers for composing custom escape-room sequences and adding contributed rooms or room packs.}
