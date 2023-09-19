#' An S4 class to declare a demand in the model
#'
#' @slot name short name (character) used in sets.
#' @slot info optional info, comment (character).
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
    info = "character",
    commodity = "character",
    unit = "character",
    dem = "data.frame",
    region = "character",
    misc = "list"
  ),
  prototype(
    name = "",
    info = "",
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
#' @param info
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
    info = character(),
    commodity = character(),
    unit = character(),
    dem = data.frame(),
    region = character(),
    misc = list())
{
  .data2slots("demand", name,
    info = info,
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
