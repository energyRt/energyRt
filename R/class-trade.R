#' An S4 class to represent inter-regional trade
#'
#' @slot name character. Short name of the trade object, used in sets.
#' @slot desc character. Description of the trade object.
#' @slot commodity character. The traded commodity short name.
#' @slot routes data.frame. Source and destination regions. For bivariate trade define both directions.
#' @slot trade data.frame. Technical parameters of trade.
#' @slot aux data.frame. Auxiliary commodity of trade.
#' @slot aeff data.frame. Auxiliary commodity efficiency parameters.
#' @slot invcost data.frame. Investment cost, used when capacityVariable is TRUE.
#' @slot olife numeric. Operational life of the trade object.
#' @slot start numeric. Start year when the trade-type of process is available for investment.
#' @slot end numeric. End year when the trade-type of process is available for investment.
#' @slot stock data.frame. Capacity stock of the trade object.
#' @slot capacityVariable logical. If TRUE, the capacity variable of the trade object is used. If FALSE, the capacity is defined by availability parameters (`ava.*`) in the trade-flow units.
#' @slot cap2act numeric. Capacity to activity ratio.
#' @slot misc list. Additional information.
#' @slot fixom data.frame. (not implemented!) Fixed operation and maintenance costs.
#' @slot varom data.frame. (not implemented!) Variable operation and maintenance costs.
#' @slot capacity data.frame. (not implemented!) Capacity parameters of the trade object.
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
    desc = "character", # Details
    commodity = "character", # Vector if NULL that
    routes = "data.frame",
    # Performance parameters
    trade = "data.frame",
    aux = "data.frame", #
    aeff = "data.frame", #  Commodity efficiency
    invcost = "data.frame",
    fixom = "data.frame", # !!!ToDo: add fixom
    varom = "data.frame", # !!!ToDO: add varom
    olife = "data.frame",
    start = "data.frame",
    end = "data.frame",
    # stock = "data.frame", # !!!ToDo: deprecate (move to @capacity)
    capacity = "data.frame", # !!!ToDo: not implemented yet
    capacityVariable = "logical",
    cap2act = "numeric", #
    optimizeRetirement = "logical", # !!!ToDo: add early retirement
    misc = "list"
  ),
  # Default values and structure of slots
  prototype(
    # General information
    name = "", # name in sets
    desc = "",
    commodity = NULL, #
    routes = data.frame(
      src = character(),
      dst = character(),
      stringsAsFactors = FALSE
    ),
    trade = data.frame(
      src = character(),
      dst = character(),
      year = integer(),
      slice = character(),
      ava.up = numeric(),
      ava.fx = numeric(),
      ava.lo = numeric(),
      # cost = numeric(), # !!!ToDo: move to varom
      # markup = numeric(), # !!!ToDo: move to varom
      teff = numeric(),
      stringsAsFactors = FALSE
    ),
    fixom = data.frame(
      region = character(),
      year = integer(),
      fixom = numeric(),
      stringsAsFactors = FALSE
    ),
    varom = data.frame(
      src = character(),
      dst = character(),
      year = integer(),
      varom = numeric(),
      markup = numeric(),
      stringsAsFactors = FALSE
    ),
    invcost = data.frame(
      region = character(),
      year = integer(),
      invcost = numeric(),
      wacc = numeric(),
      retcost = numeric(),
      stringsAsFactors = FALSE
    ),
    # olife = Inf, # !!!ToDo: change to data.frame for consistency
    # start = -Inf, # !!!ToDo: change to data.frame for consistency
    # end = Inf, # !!!ToDo: change to data.frame for consistency
    olife = data.frame(
      year = integer(),
      olife = integer(),
      stringsAsFactors = FALSE
    ),
    start = data.frame(
      # start = integer(),
      start = -Inf, # temporary, ToDO: similar to other processes
      stringsAsFactors = FALSE
    ),
    end = data.frame(
      # end = integer(),
      end = Inf,  # temporary, ToDO: similar to other processes
      stringsAsFactors = FALSE
    ),
    # stock = data.frame(
    #   year = integer(),
    #   stock = numeric(),
    #   stringsAsFactors = FALSE
    # ),
    capacity = data.frame(
      # region = character(),
      year = integer(),
      stock = numeric(),
      cap.lo = numeric(),
      cap.up = numeric(),
      cap.fx = numeric(),
      ncap.lo = numeric(),
      ncap.up = numeric(),
      ncap.fx = numeric(),
      ret.lo = numeric(),
      ret.up = numeric(),
      ret.fx = numeric(),
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
      year = integer(),
      slice = character(),
      csrc2aout = numeric(),
      csrc2ainp = numeric(),
      cdst2aout = numeric(),
      cdst2ainp = numeric(),
      stringsAsFactors = FALSE
    ),
    cap2act = 1, #
    optimizeRetirement = FALSE,
    misc = list()
  ),
  S3methods = FALSE
)

setMethod("initialize", "trade", function(.Object, ...) {
  .Object
})

setGeneric("newTrade", function(name, ...) standardGeneric("newTrade"))
#' @family trade
#' @export
setMethod("newTrade", signature(name = "character"),
          function(name, ..., source = NULL, destination = NULL, avaUpDef = Inf) {
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


