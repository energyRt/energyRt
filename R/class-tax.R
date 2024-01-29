#' An S4 class to represent a commodity tax
#'
#' @slot name character. Name of
#' @slot comm character.
#' @slot desc character.
#' @slot region character.
#' @slot year numeric.
#' @slot defVal numeric.
#' @slot value data.frame.
#' @slot misc list.
#'
#' @export
#'
#' @include class-weather.R
#'
# !!! add slot "tax" = data.frame(comm, year, slice, tax)
# !!! add slot @variable = factor("output", "balance")
setClass("tax",
  representation(
    name = "character", #
    desc = "character", #
    comm = "character", #
    region = "character", #
    defVal = "numeric", #
    tax = "data.frame", #
    misc = "list"
  ),
  prototype(
    name = "", # Short name
    comm = "",
    desc = "",
    region = character(), #
    defVal = 0, #
    tax = data.frame(
      region = character(),
      year = integer(),
      slice = character(),
      inp = numeric(),
      out = numeric(),
      bal = numeric(),
      stringsAsFactors = FALSE
    ),
    # ! Misc
    misc = list()
  ),
  S3methods = FALSE
)

setGeneric("newTax", function(name, ...) standardGeneric("newTax"))

#' @export
setMethod("newTax", signature(name = "character"), function(name, ...) {
  .data2slots("tax", name, ...)
})
