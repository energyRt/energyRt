#' An S4 class to represent commodity import from the rest of the world.
#'
#' @slot name character.
#' @slot desc character.
#' @slot commodity character.
#' @slot unit character.
#' @slot reserve numeric.
#' @slot imp data.frame.
#@slot timeframe character. - depreciated
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
    desc = "character",
    commodity = "character",
    unit = "character",
    reserve = "numeric",
    imp = "data.frame",
    # timeframe = "character", # setting to commodity@timeframe
    misc = "list"
  ),
  prototype(
    name = "",
    desc = "",
    commodity = "",
    unit = "",
    reserve = Inf,
    imp = data.frame(
      region = character(),
      year = integer(),
      slice = character(),
      imp.lo = numeric(),
      imp.up = numeric(),
      imp.fx = numeric(),
      price = numeric(),
      stringsAsFactors = FALSE
    ),
    # timeframe = character(),
    misc = list()
  ),
  S3methods = FALSE
)
setMethod("initialize", "import", function(.Object, ...) {
  .Object
})

#' Create new export object
#'
#' @name newImport
#'
#' @export
#'
#' @param name character name of the object (used in sets)
#' @param desc optional character description
#' @param commodity character name of the import commodity
#' @param unit character name of unit of the commodity
#' @param reserve numeric, total accumulated limit through the model horizon
#' @param imp data frame with import parameters
#' @param ...
newImport <- function(
    name,
    desc = "",
    commodity = "",
    unit = NULL,
    reserve = Inf,
    imp = data.frame(),
    ...) {
  .data2slots(
    "import", name,
    desc = desc,
    commodity = commodity,
    unit = unit,
    reserve = reserve,
    imp = imp,
    ...)
}

#' @param object an S4 class object to be updated.
#'
#' @param ... slot-names with data to update the S4 object
#'
#' @rdname update
#' @family update import
#' @method update import
#' @export
setMethod("update", "import", function(object, ...) {
  .data2slots("import", object, ...)
})
