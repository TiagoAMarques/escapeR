.bundled_room_packs <- function() {
  list()
}

.register_bundled_room_packs <- function(packs = .bundled_room_packs()) {
  if (!is.list(packs)) {
    stop("`.bundled_room_packs()` must return a list of room packs.", call. = FALSE)
  }
  for (pack in packs) {
    register_room_pack(pack)
  }
  invisible(vapply(packs, `[[`, character(1), "id"))
}

.onLoad <- function(libname, pkgname) {
  .register_bundled_room_packs()
}
