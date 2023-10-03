#' An S4 class to represent commodity export to the rest of the world.
#'
#' @slot name character.
#' @slot desc character.
#' @slot commodity character.
#' @slot unit character.
#' @slot reserve numeric.
#' @slot exp data.frame.
#' @slot slice character.
#' @slot misc list.
#'
#' @include class-import.R
#'
#' @export
#'
setClass("export",
  representation(
    name = "character",
    desc = "character",
    commodity = "character",
    unit = "character",
    # region !!! add
    reserve = "numeric",
    exp = "data.frame",
    slice = "character",
    misc = "list"
  ),
  prototype(
    name = "", # ...
    desc = "",
    commodity = "",
    unit = "",
    reserve = Inf,
    exp = data.frame(
      region = character(),
      year = integer(),
      slice = character(),
      exp.lo = numeric(),
      exp.up = numeric(),
      exp.fx = numeric(),
      price = numeric(),
      stringsAsFactors = FALSE
    ),
    # GIS           = NULL,
    slice = character(),
    # ! Misc
    misc = list()
  ),
  S3methods = FALSE
)

setMethod("initialize", "export", function(.Object, ...) {
  .Object
})

#' Create new export object
#'
#' @name newExport
#'
#' @export
#'
#' @param name
#' @param desc
#' @param commodity
#' @param unit
#' @param reserve
#' @param exp
#' @param ...
newExport <- function(
    name,
    desc = "",
    commodity = "",
    unit = NULL,
    reserve = Inf,
    exp = data.frame(),
    ...) {
  .data2slots("export",
    name,
    desc = desc,
    commodity = commodity,
    unit = unit,
    reserve = reserve,
    exp = exp,
    ...)
}

#' @param object object of class export
#'
#' @param ... slot-names with data to update (see `newTechnology`)
#'
#' @rdname newTechnology
#' @family update export
#' @method update export
#' @export
setMethod("update", "export", function(object, ...) {
  .data2slots("export", object, ...)
})

