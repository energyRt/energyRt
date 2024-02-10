#' An S4 class to declare a demand in the model
#'
#' @slot name short name (character) used in sets.
#' @slot desc optional desc, comment (character).
#' @slot commodity character. Name of the commodity for which the demand will be specified.
#' @slot unit character. (optional) unit of the commodity.
#' @slot dem specification of the demand, a data.frame with columns:
#' \describe{
#'   \item{region}{character. Name of the region for which the demand will be specified. NA for every regions}'
#'   \item{year}{integer. Year of the demand. NA for every year.}
#'   \item{slice}{character. Name of the slice for which the demand will be specified. NA for every slice.}
#'   \item{dem}{numeric. Value of the demand.}
#' }
#' @slot region character. Optional name of region to narrow the specification of the demand in the case of used NAs. Error will be returned if specified regions in `@dem` are not mensioned in the `@region` slot (if the slot is not empty).
#' @slot misc list. Optional list of additional information.
#'
#' @include class-commodity.R
#' @rdname demand
#'
#' @export
#'
setClass("demand",
  representation(
    name = "character",
    desc = "character",
    commodity = "character",
    unit = "character",
    dem = "data.frame",
    region = "character",
    misc = "list"
  ),
  prototype(
    name = "",
    desc = "",
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

#' @rdname demand
#' @order 1
#' @return demand object with given specifications.
#' @export
#'
#' @examples
newDemand <- function(
    name = "",
    desc = character(),
    commodity = character(),
    unit = character(),
    dem = data.frame(),
    region = character(),
    misc = list())
{
  .data2slots("demand", name,
    desc = desc,
    commodity = commodity,
    unit = unit,
    dem = dem,
    region = region,
    misc = misc
  )
}

#' @name update
#' @param object demand object
#'
#' @rdname update
#' @family demand update
#' @keywords demand update
#' @export
setMethod("update", signature(object = "demand"), function(object, ...) {
  .data2slots("demand", object, ...)
})

