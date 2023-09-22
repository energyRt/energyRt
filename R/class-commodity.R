#' An S4 class to represent a commodity
#'
#' @slot name short name, used in sets, no white spaces or special characters
#' @slot description (optional) description of
#' @slot limtype limit type of the commodity in balance equation ("LO" by default)
#' @slot slice the level of time-slice the commodity operates in the model
#'             (the lowest slice-level used by default)
#' @slot unit the main unit of the commodity used in the model, character string
#' @slot emis data.frame with emissions factors, see details
#' @slot agg data.frame with aggregation parameters of several commodities into one
#' @slot misc list with miscellaneous information to store
#'
#' @include class-calendar.R
#'
setClass("commodity",
  representation(
    name = "character", # Short name
    desc = "character", # Details
    limtype = "factor",
    slice = "character",
    unit = "character",
    emis = "data.frame", # Emission factors
    agg = "data.frame", # Aggregation parameter
    misc = "list"
  ),
  prototype(
    name = character(),
    desc = character(),
    limtype = factor("LO", levels = c("FX", "UP", "LO")),
    slice = character(),
    unit = character(),
    agg = data.frame(
      comm = character(),
      unit = numeric(),
      agg = numeric(),
      stringsAsFactors = FALSE
    ),
    emis = data.frame(
      comm = character(),
      unit = character(),
      emis = numeric(),
      stringsAsFactors = FALSE
    ),
    misc = list()
  ),
  S3methods = FALSE
)

setMethod("initialize", "commodity", function(.Object, ...) {
  .Object
})

#' Create class commodity
#'
#' @param name
#' @param desc
#' @param limtype
#' @param slice
#' @param unit
#' @param agg
#' @param emis
#' @param misc
#'
#' @return
#' @export
#'
#' @examples
newCommodity <- function(
    name = "",
    desc = "",
    limtype = "LO",
    slice = character(),
    unit = character(),
    agg = data.frame(),
    emis = data.frame(),
    misc = list()) {
  .data2slots("commodity", name,
    desc = "",
    limtype = "LO",
    slice = slice,
    unit = unit,
    agg = agg,
    emis = emis,
    misc = misc
  )
}

# update.commodity <- function(obj, ...) .data2slots("commodity", obj, ...)

#' @importFrom stats update
#' @rdname commodity
#' @family commodity update
#' @export
setMethod("update", signature(object = "commodity"), function(object, ...) {
  # update.supply <- function(obj, ...) {
  .data2slots("commodity", object, ...)
})
