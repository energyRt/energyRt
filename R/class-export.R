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
    reserve = "numeric",
    exp = "data.frame",
    slice = "character",
    misc = "list"
  ),
  prototype(
    name = "",
    desc = "",
    commodity = "",
    unit = "",
    reserve = Inf,
    exp = data.frame(
      region = character(),
      year = numeric(),
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

setGeneric("newExport", function(name, ...) standardGeneric("newExport"))
#' Create new export object
#'
#' @name newExport
#'
#' @export
setMethod("newExport", signature(name = "character"), function(name, ...) {
  .data2slots("export", name, ...)
})

# setMethod('update', signature(obj = 'export'), function(obj, ...)
#' @export
update.export <- function(obj, ...) {
  .data2slots("export", obj, ...)
}
