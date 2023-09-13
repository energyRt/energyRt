#' An S4 class to represent a commodity tax
#'
#' @slot name character.
#' @slot comm character.
#' @slot description character.
#' @slot region character.
#' @slot year numeric.
#' @slot slice character.
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
    description = "character", #
    comm = "character", #
    region = "character", #
    defVal = "numeric", #
    tax = "data.frame", #
    misc = "list"
  ),
  prototype(
    name = "", # Short name
    comm = "",
    description = "",
    region = character(), #
    defVal = 0, #
    tax = data.frame(
      region = character(),
      year = numeric(),
      slice = character(),
      inp = numeric(),
      out = numeric(),
      bal = numeric(),
      stringsAsFactors = FALSE
    ),
    # ! Misc
    misc = list()
  ),
  S3methods = TRUE
)

setGeneric("newTax", function(name, ...) standardGeneric("newTax"))

#' @export
setMethod("newTax", signature(name = "character"), function(name, ...) {
  .data2slots("tax", name, ...)
})
