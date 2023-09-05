#' Title
#'
#' @slot name character.
#' @slot description character.
#' @slot unit character.
#' @slot region character.
#' @slot slice character.
#' @slot defVal numeric.
#' @slot weather data.frame.
#' @slot misc list.
#'
#' @include class-export.R
#'
#' @export
#'
setClass("weather",
  representation(
    name = "character",
    description = "character",
    unit = "character",
    region = "character",
    slice = "character",
    defVal = "numeric",
    weather = "data.frame", # weather factor (availability multiplier)
    misc = "list"
  ),
  prototype(
    name = "",
    description = "",
    unit = as.character(NA),
    region = character(),
    slice = character(),
    defVal = 0.,
    weather = data.frame(
      region = character(), #
      year = numeric(),
      slice = character(),
      wval = numeric(),
      stringsAsFactors = FALSE
    ),
    misc = list()
  ),
  S3methods = TRUE
)
setMethod("initialize", "weather", function(.Object, ...) {
  .Object
})

setGeneric("newWeather", function(name, ...) standardGeneric("newWeather"))
#' Create new weather object
#'
#' @name newWeather
#'
setMethod("newWeather", signature(name = "character"), function(name, ...) {
  .data2slots("weather", name, ...)
})

# setMethod('update', signature(obj = 'weather'), function(obj, ...)
update.weather <- function(obj, ...) {
  .data2slots("weather", obj, ...)
}
