#' An S4 class to represent a commodity tax
#'
#' @inherit newSub, description
#' @slot name character. 
#' @slot comm character.
#' @slot desc character.
#' @slot region character.
#' @slot year numeric.
#' @slot defVal numeric.
#' @slot value data.frame.
#' @slot misc list.
#'
#' @include class-weather.R
#' @rdname class-tax
#'
#' @export
#'
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
  # !!! add slot "tax" = data.frame(comm, year, slice, tax)
  # !!! add slot @variable = factor("output", "balance")
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

# setGeneric("newTax", function(name, ...) standardGeneric("newTax"))
#' @title Create a new tax object
#' 
#' @description
#' Taxes are used to represent the financial levy imposed on production,
#' consumption, or balance of a commodity.
#' 
#' @param name `r get_slot_info("tax", "name")`
#' @param desc `r get_slot_info("tax", "desc")`
#' @param comm `r get_slot_info("tax", "comm")`
#' @param region `r get_slot_info("tax", "region")`
#' @param defVal `r get_slot_info("tax", "defVal")`
#' @param tax `r get_slot_info("tax", "tax")`
#' @param misc `r get_slot_info("tax", "misc")`
#'
#' @return An object of class `tax`
#' @rdname newTax
#' @export
#'
#' @examples
newTax <- function(
  name, 
  desc = "",
  comm = "",
  region = character(),
  defVal = 0,
  tax = data.frame(),
  misc = list()
  ) {
  .data2slots(
    "tax", 
    name = name,
    desc = desc,
    comm = comm,
    region = region,
    defVal = defVal,
    tax = tax,
    misc = misc
    )  
}

# setMethod("newTax", signature(name = "character"), function(name, ...) {
#   .data2slots("tax", name, ...)
# })
