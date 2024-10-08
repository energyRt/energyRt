# load("R/sysdata.rda")
#' Class (S4) to represent default model configuration.
#'
#' @slot desc character string with the configuration information.
#' @slot region character coma separated string of all region names in the model
#' @slot horizon class horizon with the model time parameters
#' @slot discount data frame with discount rates by region and year
#' @slot discountFirstYear logical, if TRUE, the discounting starts from the beginning of the year
#' @slot optimizeRetirement currently ignored
#' @slot defVal data.frame with default values of parameters (energyRt:::.defVal)
#' @slot interpolation data.frame with interpolation rules (energyRt:::.defInt)
#' @slot debug data.frame to define artificial (dummy) variables to debug model infeasibility
#' @slot misc list with miscelaneous data to store in the object.
#'
#' @include class-calendar.R class-horizon.R
#'
#' @export
setClass("config",
  representation(
    name = "character",
    desc = "character",
    region = "character",
    horizon = "horizon", # change to class
    # year = "numeric", # move to horizon
    calendar = "calendar",
    # slice = "slice", #
    # yearFraction = "data.frame",
    discount = "data.frame",
    discountFirstYear = "logical",
    optimizeRetirement = "logical",
    defVal = "data.frame",
    interpolation = "data.frame",
    debug = "data.frame",
    misc = "list"
  ),
  prototype(
    name = "default",
    desc = "model configuration",
    debug = data.frame(
      comm = character(),
      region = character(),
      year = integer(),
      slice = character(),
      dummyImport = numeric(),
      dummyExport = numeric(),
      stringsAsFactors = FALSE
    ),
    discount = data.frame(
      region = character(),
      year = integer(),
      discount = numeric(),
      wacc = numeric(),
      # sdr = numeric(),
      stringsAsFactors = FALSE
    ),
    region = NULL,
    # year = as.numeric(2005:2050),
    horizon = new("horizon"),
    calendar = newCalendar(),
    # slice = new("slice"),
    discountFirstYear = FALSE,
    optimizeRetirement = FALSE,
    defVal = data.frame(),
    interpolation = data.frame(),
    # defVal = as.data.frame(.defVal, stringsAsFactors = FALSE),
    # interpolation = as.data.frame(.defInt, stringsAsFactors = FALSE),
    # yearFraction = data.frame(
    #   year = as.numeric(NA),
    #   fraction = as.numeric(1),
    #   stringsAsFactors = FALSE
    # ),
    misc = list()
  ),
  S3methods = FALSE
)
setMethod("initialize", "config", function(.Object, ...) {
  # browser()
  if (!exists(".defVal") || !exists(".modInp") || !exists(".defInt")) {
    load("R/sysdata.rda")
  }
  # if (!is.null()) # add import from .defInt
  .Object@defVal <- as.data.frame(energyRt:::.defVal, stringsAsFactors = FALSE)
  .Object@interpolation <- as.data.frame(energyRt:::.defInt, stringsAsFactors = FALSE)
  .Object
})

# @export
# setGeneric("setTimeSlices", function(obj, ...) standardGeneric("setTimeSlices"))

# @export
# setMethod("setTimeSlices", signature(obj = "config"), function(obj, ...) {
#   obj@slice <- .setTimeSlices(...)
#   obj
# })

# setGeneric("setCalendar", function(obj, ...) standardGeneric("setCalendar"))

#' @export
setMethod("setCalendar", signature(obj = "config"), function(obj, ...) {
  obj@calendar <- newCalendar(...) ## ToDo: add check for fractional data
  obj
})

# setGeneric("setHorizon",
#            function(obj, horizon, intervals) standardGeneric("setHorizon"))

#' @param obj .
#'
#' @param horizon .
#'
#' @export
setMethod(
  "setHorizon", signature(obj = "config"), function(obj, period, ...) {
    # browser()
    # obj@horizon <- milestoneYears(start, interval)
    # obj@year <- min(obj@horizon@intervals$start):max(obj@horizon@intervals$end)
    obj@horizon <- newHorizon(period = period, ...)
    obj
  }
)
# setGeneric("getHorizon", function(obj) standardGeneric("getHorizon"))

#' @export
setMethod("getHorizon", signature(obj = "config"), function(obj) obj@horizon)

#' @rdname newConfig
#' @family update config
#' @method update config
#' @export
setMethod("update", "config", function(object, ..., warn_nodata = TRUE) {
  # browser()
  # !!! add no-data check for warning
  cf <- .data2slots("config", object, ..., warn_nodata = FALSE)
  cf@calendar <- .data2slots("calendar", cf@calendar, ...,
                             ignore_args = c("name", "desc", "misc"),
                             warn_nodata = FALSE)
  cf@horizon <-  .data2slots("horizon", cf@horizon, ...,
                             ignore_args = c("name", "desc", "misc"),
                             warn_nodata = FALSE)
  cf
})



# setGeneric("milestoneYears",
#            function(start, interval) standardGeneric("milestoneYears"))
#
# setMethod("milestoneYears",
#           signature(start = "numeric", interval = "numeric"),
#           function(start, interval) {
#             browser()
#   if (interval[1] != 1) stop("setMileStoneYears: first interval have to be 1")
#   mlst <- data.frame(
#     start = start + cumsum(c(0, interval[-length(interval)])),
#     mid = rep(NA, length(interval)),
#     end = start + cumsum(interval) - 1
#   )
#   mlst[, "mid"] <- trunc(.5 * (mlst[, "start"] + mlst[, "end"]))
#   mlst
# })


