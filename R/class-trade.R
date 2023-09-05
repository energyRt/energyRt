#' An S4 class to represent inter-regional trade
#'
#' @slot name character.
#' @slot description character.
#' @slot commodity character.
#' @slot routes data.frame.
#' @slot trade data.frame.
#' @slot aux data.frame.
#' @slot aeff data.frame.
#' @slot invcost data.frame.
#' @slot olife numeric.
#' @slot start numeric.
#' @slot end numeric.
#' @slot stock data.frame.
#' @slot capacityVariable logical.
#' @slot cap2act numeric.
#' @slot misc list.
#'
#' @include class-storage.R
#'
#' @return
#' @export
#'
setClass("trade",
  representation(
    # General information
    name = "character", # Short name
    description = "character", # Details
    commodity = "character", # Vector if NULL that
    routes = "data.frame",
    # Performance parameters
    trade = "data.frame",
    aux = "data.frame", #
    aeff = "data.frame", #  Commodity efficiency
    invcost = "data.frame",
    # fixom = "data.frame", # !!!ToDo: add fixom
    # varom = "data.frame", # !!!ToDO: add varom
    olife = "numeric",
    start = "numeric",
    end = "numeric",
    stock = "data.frame",
    capacityVariable = "logical",
    cap2act = "numeric", #
    misc = "list"
  ),
  # Default values and structure of slots
  prototype(
    # General information
    name = "", # name in sets
    description = "",
    commodity = NULL, #
    routes = data.frame(
      src        = character(),
      dst        = character(),
      stringsAsFactors = FALSE
    ),
    trade = data.frame(
      src = character(),
      dst = character(),
      year = numeric(),
      slice = character(),
      ava.up = numeric(),
      ava.fx = numeric(),
      ava.lo = numeric(),
      cost = numeric(),
      markup = numeric(),
      teff = numeric(),
      stringsAsFactors = FALSE
    ),
    invcost = data.frame(
      region = character(),
      year = numeric(),
      invcost = numeric(),
      stringsAsFactors = FALSE
    ),
    olife = Inf, # change to data.frame for consistency?
    start = -Inf, # change to data.frame for consistency?
    end = Inf, # change to data.frame for consistency?
    stock = data.frame(
      year = integer(),
      stock = numeric(),
      stringsAsFactors = FALSE
    ),
    capacityVariable = FALSE,
    aux = data.frame(
      acomm = character(),
      unit = character(),
      stringsAsFactors = FALSE
    ),
    # Auxiliary commodity parameters
    aeff = data.frame(
      acomm = character(),
      src = character(),
      dst = character(),
      year = numeric(),
      slice = character(),
      csrc2aout = numeric(),
      csrc2ainp = numeric(),
      cdst2aout = numeric(),
      cdst2ainp = numeric(),
      stringsAsFactors = FALSE
    ),
    cap2act = 1, #
    misc = list()
  ),
  S3methods = TRUE
)

setMethod("initialize", "trade", function(.Object, ...) {
  .Object
})

setGeneric("newTrade", function(name, ...) standardGeneric("newTrade"))
setMethod("newTrade", signature(name = "character"), function(name, ..., source = NULL, destination = NULL, avaUpDef = Inf) {
  trd <- .data2slots("trade", name, ...)
  if (avaUpDef != Inf) {
    trd@trade[nrow(trd@trade) + 1, ] <- NA
    trd@trade[nrow(trd@trade), "ava.up"] <- avaUpDef
  }
  if (is.null(source) != is.null(destination)) {
    stop('Inconsistency of source/destination data "', trd@name, '"')
  }
  if (!is.null(source) && !is.null(list(...)$routes)) {
    stop('Inconsistency of source/destination with routes data "', trd@name, '"')
  }
  if (!is.null(source)) {
    trd@routes <- merge(
      data.frame(src = source, stringsAsFactors = FALSE),
      data.frame(dst = destination, stringsAsFactors = FALSE)
    )
    trd@routes <- trd@routes[trd@routes$src != trd@routes$dst, , drop = FALSE]
  }
  trd
})


