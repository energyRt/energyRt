#' An S4 class to represent scenario, an interpolated and/or solved model.
#'
#' @slot name character.
#' @slot info character.
#' @slot model model.
#' @slot subset
#' @slot settings settings.
#' @slot modInp modInp.
#' @slot modOut modOut.
#' @slot source list.
#' @slot solver list.
#' @slot status list.
#' @slot misc list.
#'
#' @include class-modOut.R class-settings.R
#'
#' @return
#' @export
setClass("scenario",
  representation(
    name = "character",
    info = "character",
    model = "model",
    # subset = list(),
    settings = "settings",
    modInp = "modInp",
    modOut = "modOut",
    # source = "list", # Model/scenario source code
    status = "list",
    inMemory = "logical", # reserved
    path = "character", # reserved
    misc = "list"
  ),
  prototype(
    name = NULL,
    info = NULL,
    model = NULL,
    # subset = list(),
    settings = NULL,
    modInp = NULL,
    modOut = NULL,
    # source = list(), # Model source
    # solver = list(),
    status = list(
      interpolated = FALSE,
      optimal = FALSE
    ),
    inMemory = TRUE,
    path = character(),
    misc = list()
  ),
  S3methods = FALSE
)

setMethod("initialize", "scenario", function(.Object, ...) {
  .Object
})

# summary <- function(...) UseMethod("summary")

summary.scenario <- function(object, ...) {
  # browser()
  scen <- object
  cat("Scenario:", scen@name, "\n")
  cat("Model:", scen@model@name, "\n")
  cat("Interpolated:", scen@status$interpolated, "\n")
  if (scen@status$interpolated) {
    if (!is.null(scen@modOut) && scen@modOut@stage == "solved") {
      cat("Solution status: ", ifelse(scen@status$optimal, "", "NOT "), "optimal\n", sep = "")
      vObj <- getData(scen, "vObjective", merge = T)
      cat("vObjective: ", vObj$value, "\n")
      dum <- sum(scen@modOut@variables$vDummyCost$value)
      if (abs(dum) > 0) {
        cat("Dummy import/export costs: ", dum, "\n")
      }
    } else if (is.null(scen@modOut)) { # not solved
      cat("Solution status: not solved\n")
    } else {
      status <- try(scen@modOut@stage)
      if (class(status) == "try-error") status <- "unknown"
      cat("Solution status:", status,"\n")
    }
  }
  cat("Size:", size(scen),"\n")
}
#' @rdname summary
#' @method summary scenario
#' @export
setMethod("summary", signature(object = "scenario"),
          definition = summary.scenario)
# setMethod("summary", "scenario", summary.scenario)


# @export
# setMethod("setTimeSlices", signature(obj = "scenario"), function(obj, ...) {
#   obj@model@settings@slice <- .setTimeSlices(...)
#   obj
# })

#' @export
setMethod("setHorizon", signature(obj = "scenario"),
  function(obj, horizon, intervals) {
    obj@model <- setHorizon(obj@model, horizon, intervals)
    obj
  }
)

#' @export
setMethod("getHorizon", signature(obj = "scenario"), function(obj) {
  getHorizon(obj@model)
})

# .modelCode <- list(
#   GAMS = readLines("gams/energyRt.gms"),
#   JuMP = readLines("julia/energyRt.jl"),
#   JuMPOutput = readLines("julia/energyRtOutput.jl"),
#   PYOMOConcrete = readLines("pyomo/energyRtConcrete.py"),
#   PYOMOConcreteOutput = readLines("pyomo/energyRtConcreteOutput.py"),
#   PYOMOAbstract = readLines("pyomo/energyRtAbstract.py"),
#   PYOMOAbstractOutput = readLines("pyomo/energyRtAbstractOutput.py"),
#   GLPK = readLines("glpk/energyRt.mod"),
#   GAMS_output = readLines("gams/output.gms"),
#   checkGAMS = readLines("gams/check.gms"),
#   checkJULIA = readLines("julia/check.jl"),
#   checkPYOMO = readLines("pyomo/check.py"),
#   checkGLPK = readLines("glpk/check.mod")
# )
