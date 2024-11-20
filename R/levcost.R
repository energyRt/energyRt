# levelized costs methods for model, scenario, and other objects ###############

#' Calculate levelized costs of commodity production
#'
#' @param object model, scenario, or technology object
#' @param comm commodity name for which to calculate levelized costs
#' @param name name of the object for which to calculate levelized costs
#' @param ...
#'
#' @return
#' @export
#'
#' @include solve.R
#' @examples
#' NA
setGeneric("levcost", function(object, comm, name, ...) {
  standardGeneric("levcost")
})

setMethod("levcost", "model", function(object, comm, name, ...) {
  levcost.model(object, comm = NULL, name = object@name, ...)
})

setMethod("levcost", "scenario", function(object, comm, name, ...) {
  levcost.scenario(object, comm = NULL, name = object@name, ...)
})

setMethod("levcost", "technology", function(object, comm, name, ...) {
  levcost.technology(object, comm = NULL, name = object@name, ...)
})

levcost.model <- function(object, comm, name, ...) {
  message("levcost.model")
  return(NA)
}

levcost.scenario <- function(object, comm, name, ...) {
  # options:
  #   1. solved scenario,
  #   2. interpolated scenario,
  #   3. not-interpolated -> levcost.model
  # if scenario is solved, the result will be taken to calculate levelized costs
  # for all demanded commodities, considering export as a credit or external demand




  return(NA)
}
