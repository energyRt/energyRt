#' An S4 class to represent storage type of technological process.
#'
#' @details
#' Storage type of technological processes are characterized by the same input and output commodity, and the accumulating capacity for the commodity.
#'
#'
#' @slot name character.
#' @slot description character.
#' @slot commodity character.
#' @slot start data.frame.
#' @slot end data.frame.
#' @slot aux data.frame.
#' @slot olife data.frame.
#' @slot stock data.frame.
#' @slot charge data.frame.
#' @slot seff data.frame.
#' @slot af data.frame.
#' @slot aeff data.frame.
#' @slot fixom data.frame.
#' @slot varom data.frame.
#' @slot invcost data.frame.
#' @slot fullYear logical.
#' @slot region character.
#' @slot cap2stg numeric.
#' @slot weather data.frame.
#' @slot misc list.
#'
#' @include class-technology.R
#'
#' @return
#' @export
#'
setClass("storage",
  representation(
    name = "character",
    description = "character",
    commodity = "character",
    aux = "data.frame", #
    region = "character",
    start = "data.frame",
    end = "data.frame",
    olife = "data.frame", #
    stock = "data.frame", #
    charge = "data.frame", #
    seff = "data.frame", #
    af = "data.frame", # Availability of the resource with prices
    aeff = "data.frame", #  Commodity efficiency
    fixom = "data.frame", #
    varom = "data.frame", #
    invcost = "data.frame",
    fullYear = "logical",
    cap2stg = "numeric", # cap2stg cinp
    weather = "data.frame", # weather condisions multiplier
    misc = "list" #
  ),
  prototype(
    name = "",
    description = "",
    commodity = "",
    start = data.frame(
      region = character(),
      start = numeric(),
      stringsAsFactors = FALSE
    ),
    end = data.frame(
      region = character(),
      end = numeric(),
      stringsAsFactors = FALSE
    ),
    olife = data.frame(
      region = character(),
      # year = integer(), # add year to distinguish vintages
      olife = numeric(),
      stringsAsFactors = FALSE
    ),
    charge = data.frame(
      region = character(),
      year = numeric(),
      slice = numeric(),
      charge = numeric(),
      stringsAsFactors = FALSE
    ),
    stock = data.frame(
      region = character(),
      year = numeric(),
      stock = numeric(),
      stringsAsFactors = FALSE
    ),
    seff = data.frame(
      region = character(),
      year = numeric(),
      slice = character(),
      stgeff = numeric(),
      inpeff = numeric(),
      outeff = numeric(),
      stringsAsFactors = FALSE
    ),
    aux = data.frame(
      acomm = character(),
      unit = character(),
      stringsAsFactors = FALSE
    ),
    aeff = data.frame(
      acomm = character(),
      region = character(),
      year = numeric(),
      slice = character(),
      stg2ainp = numeric(),
      cinp2ainp = numeric(),
      cout2ainp = numeric(),
      stg2aout = numeric(),
      cinp2aout = numeric(),
      cout2aout = numeric(),
      cap2ainp = numeric(),
      cap2aout = numeric(),
      ncap2ainp = numeric(),
      ncap2aout = numeric(),
      ncap2stg = numeric(),
      stringsAsFactors = FALSE
    ),
    af = data.frame(
      region = character(),
      year = numeric(),
      slice = character(),
      af.lo = numeric(),
      af.up = numeric(),
      af.fx = numeric(),
      cinp.up = numeric(),
      cinp.fx = numeric(),
      cinp.lo = numeric(),
      cout.up = numeric(),
      cout.fx = numeric(),
      cout.lo = numeric(),
      stringsAsFactors = FALSE
    ),
    fixom = data.frame(
      region = character(),
      year = numeric(),
      fixom = numeric(),
      stringsAsFactors = FALSE
    ),
    varom = data.frame(
      region = character(),
      year = numeric(),
      slice = character(),
      inpcost = numeric(),
      outcost = numeric(),
      stgcost = numeric(),
      stringsAsFactors = FALSE
    ),
    invcost = data.frame(
      region = character(),
      year = numeric(),
      invcost = numeric(),
      stringsAsFactors = FALSE
    ),
    cap2stg = 1,
    fullYear = TRUE,
    region = character(),
    weather = data.frame(
      weather = character(),
      waf.lo = numeric(),
      waf.up = numeric(),
      waf.fx = numeric(),
      wcinp.lo = numeric(),
      wcinp.fx = numeric(),
      wcinp.up = numeric(),
      wcout.lo = numeric(),
      wcout.fx = numeric(),
      wcout.up = numeric(),
      stringsAsFactors = FALSE
    ),
    misc = list()
  ),
  S3methods = TRUE
)

setMethod("initialize", "storage", function(.Object, ...) {
  .Object
})


setGeneric("newStorage", function(name, ...) standardGeneric("newStorage"))
#' Create new import object
#'
#' @name newStorage
#' @family storage
#' @export
#'
setMethod("newStorage", signature(name = "character"), function(name, ...) {
  .data2slots("storage", name, ...)
})

# setMethod('update', signature(obj = 'storage'), function(obj, ...)
#' @family storage update
#' @export
update.storage <- function(obj, ...) {
  .data2slots("storage", obj, ...)
}
