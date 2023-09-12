#' An S4 class to represent a commodity subsidy
#'
#' @slot name character.
#' @slot description character.
#' @slot comm character.
#' @slot region character.
#' @slot defVal numeric.
#' @slot value data.frame.
#' @slot misc list.
#'
#' @return
#' @export
#'
#' @include class-tax.R
#'
# !!! add slot "sub" = data.frame(comm, year, slice, sub)
# !!! rename sub -> subsidy
# !!! add slot @variable = factor("output", "balance")
setClass("sub",
  representation(
    # General information
    name = "character", # Short name
    description = "character", # Details
    comm = "character", #
    region = "character", #
    defVal = "numeric", #
    sub = "data.frame", #
    misc = "list"
  ),
  prototype(
    name = "", # Short name
    comm = "",
    description = "",
    region = character(), #
    defVal = 0, #
    sub = data.frame(
      region = character(),
      year = numeric(),
      slice = character(),
      inp = numeric(),
      out = numeric(),
      bal = numeric(),
      stringsAsFactors = FALSE
    ),
    misc = list()
  ),
  S3methods = TRUE
)

setGeneric("newSub", function(name, ...) standardGeneric("newSub"))

#' @export
setMethod("newSub", signature(name = "character"), function(name, ..., value = NULL) {
  .data2slots("sub", name, ...)
})
