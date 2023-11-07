#' An S4 class to represent a commodity
#'
#' @slot name character, a short name used in sets, no white spaces or special characters
#' @slot limtype, character or factor, the limit type of the commodity in balance equation ("LO" by default, meaning that the level of commodity in the model is satisfied with the lower bound)
#' @slot timeframe character, the default time-frame this commodity operates in the model
#'             (the lowest timeframe used by default)
#' @slot unit the main unit of the commodity used in the model, character string
#' @slot emis data.frame with emissions factors, columns:
#' \describe{
#'  \item{comm}{character string, name of the commodity}
#'  \item{unit}{character string, unit of the emission factor}
#'  \item{emis}{numeric, emission factor, applied to the consumed commodity (`@name`) by a technology with combustion parameter > 0, to calculate emissions of the commodity specified in the slot (`@emis$comm`).}
#' }
#' @slot agg data.frame with aggregation parameters of several commodities
#' into the `@name` commodity, with columns:
#' \describe{
#'  \item{comm}{character string, name of the commodity being aggregated}
#'  \item{unit}{numeric, unit of the commodity being aggregated}
#'  \item{agg}{numeric, aggregation parameter, applied to the commodity specified in the slot (`@agg$comm`) to calculate the `@name` commodity.}
#' }
#' @slot misc list with miscellaneous information to store
#' @slot desc
#'
#' @rdname commodity
#' @include class-calendar.R
#'
setClass("commodity",
  representation(
    name = "character", # Short name
    desc = "character", # Details
    limtype = "factor",
    timeframe = "character",
    unit = "character",
    emis = "data.frame", # Emission factors
    agg = "data.frame", # Aggregation parameter
    misc = "list"
  ),
  prototype(
    name = character(),
    desc = character(),
    limtype = factor("LO", levels = c("FX", "UP", "LO")),
    timeframe = character(),
    unit = character(),
    agg = data.frame(
      comm = character(),
      unit = character(),
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
#' @return
#' @export
#'
#' @rdname commodity
#'
#' @family sets
#'
#' @examples
#' newCommodity(name = "ELC", desc = "Electricity")
newCommodity <- function(
    name = "",
    desc = "",
    limtype = "LO",
    timeframe = character(),
    unit = character(),
    agg = data.frame(),
    emis = data.frame(),
    misc = list()) {
  .data2slots("commodity", name,
    desc = "",
    limtype = "LO",
    timeframe = timeframe,
    unit = unit,
    agg = agg,
    emis = emis,
    misc = misc
  )
}


#' @describeIn update update commodity
#' @family commodity update
#' @export
setMethod("update", signature(object = "commodity"), function(object, ...) {
  # update.supply <- function(obj, ...) {
  .data2slots("commodity", object, ...)
})
