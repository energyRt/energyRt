#' An S4 class to declare a demand in the model
#'
#' @slot name short name (character) used in sets.
#' @slot description optional description, comment (character).
#' @slot commodity character.
#' @slot unit character.
#' @slot dem data.frame.
#' @slot region character.
#' @slot misc list.
#'
#' @include class-commodity.R
#'
#' @return
#' @export
#'
setClass("demand",
  representation(
    name = "character",
    description = "character",
    commodity = "character",
    unit = "character",
    dem = "data.frame",
    region = "character",
    misc = "list"
  ),
  prototype(
    name = "",
    description = "",
    unit = "",
    region = character(),
    dem = data.frame(
      region = character(),
      year = integer(),
      slice = character(),
      dem = numeric(),
      stringsAsFactors = FALSE
    ),
    misc = list()
  ),
  S3methods = FALSE
)

setMethod("initialize", "demand", function(.Object, ...) {
  .Object
})

#' Create new demand
#'
#' @param name
#' @param description
#' @param commodity
#' @param unit
#' @param dem
#' @param region
#' @param misc
#'
#' @return
#' @export
#'
#' @examples
newDemand <- function(
    name = "",
    description = character(),
    commodity = character(),
    unit = character(),
    dem = data.frame(),
    region = character(),
    misc = list())
{
  .data2slots("demand", name,
    description = description,
    commodity = commodity,
    unit = unit,
    dem = dem,
    region = region,
    misc = misc
  )
}

update.demand <- function(obj, ...) {
  .data2slots("demand", obj, ...)
}
