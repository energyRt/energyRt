#' modOut-class to store the output from the model (solution)
#'
#' @slot sets list.
#' @slot variables list.
#' @slot stage character. # !!! move to scenario-status
#' @slot solutionLogs data.frame.
#' @slot misc list.
#'
#' @include class-modInp.R
#'
#' @export
#'
setClass("modOut",
  representation(
    sets = "list",
    # data = "list", # Should be removed
    variables = "list",
    stage = "character",
    solutionLogs = "data.frame",
    misc = "list"
  ),
  prototype(
    sets = list(),
    # data = list(),
    variables = list(),
    stage = character(),
    solutionLogs = data.frame(
      parameter = character(),
      value = character(),
      time = character()
    ),
    misc = list()
  ),
  S3methods = TRUE
)

setMethod("initialize", "modOut", function(.Object, ...) {
  .Object
})
