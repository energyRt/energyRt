#' An S4 class to represent commodity import from the rest of the world.
#'
#' @slot name character.
#' @slot info character.
#' @slot commodity character.
#' @slot unit character.
#' @slot reserve numeric.
#' @slot imp data.frame.
#' @slot slice character.
#' @slot misc list.
#'
#' @include class-trade.R
#'
#' @return
#' @export
#'
setClass("import",
  representation(
    name = "character",
    info = "character",
    commodity = "character",
    unit = "character",
    reserve = "numeric",
    imp = "data.frame",
    slice = "character",
    misc = "list"
  ),
  prototype(
    name = "",
    info = "",
    commodity = "",
    unit = "",
    reserve = Inf,
    imp = data.frame(
      region = character(),
      year = numeric(),
      slice = character(),
      imp.lo = numeric(),
      imp.up = numeric(),
      imp.fx = numeric(),
      price = numeric(),
      stringsAsFactors = FALSE
    ),
    slice = character(),
    misc = list()
  ),
  S3methods = FALSE
)
setMethod("initialize", "import", function(.Object, ...) {
  .Object
})

setGeneric("newImport", function(name, ...) standardGeneric("newImport"))
#' Create new import object
#'
#' @name newImport
#' @export
#'
setMethod("newImport", signature(name = "character"), function(name, ...) {
  .data2slots("import", name, ...)
})

# setMethod('update', signature(obj = 'import'), function(obj, ...)
#' @export
update.import <- function(obj, ...) {
  .data2slots("import", obj, ...)
}
