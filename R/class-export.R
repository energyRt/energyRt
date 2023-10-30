#' An S4 class to represent commodity export to the rest of the world.
#'
#' @slot name character. Name of the export process (used in sets).
#' @slot desc character. A short description of the export process.
#' @slot commodity character. Name of the commodity.
#' @slot unit character. Unit of the exported commodity.
#' @slot reserve numeric. Constraints on the total accumulated (over years) export resource (similar to "reserve" in supply).
#' @slot exp data.frame. Export data.frame with columns:
#'  \describe{
#'      \item{region}{character name of region or NA for all regions}
#'      \item{year}{integer year or NA for all years}
#'      \item{slice}{name of time-slices, or name timeframe to represent a group of time-slices, or NA for all time-slices}
#'      \item{exp.lo}{numeric, lower constraint on export}
#'      \item{exp.up}{numeric, upper constraint on export}
#'      \item{exp.fx}{numeric, fixed level of export}
#'      \item{price}{price of the export}.
#' @slot timeframe character. Name of timeframe for the export to operate on.
#' @slot misc list. Any additional information to store.
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
    timeframe = "character",
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
    timeframe = character(),
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

