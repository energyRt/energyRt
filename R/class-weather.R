#' Title
#'
#' @slot name character.
#' @slot desc character.
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
    desc = "character",
    unit = "character",
    region = "character",
    slice = "character",
    defVal = "numeric",
    weather = "data.frame", # weather factor (availability multiplier)
    misc = "list"
  ),
  prototype(
    name = "",
    desc = "",
    unit = as.character(NA),
    region = character(),
    slice = character(),
    defVal = 0.,
    weather = data.frame(
      region = character(), #
      year = integer(),
      slice = character(),
      wval = numeric(),
      stringsAsFactors = FALSE
    ),
    misc = list()
  ),
  S3methods = FALSE
)
setMethod("initialize", "weather", function(.Object, ...) {
  .Object
})




#' Title
#'
#' @param name
#' @param desc
#' @param unit
#' @param region
#' @param slice
#' @param defVal
#' @param weather
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
newWeather <- function(
    name = "",
    desc = "",
    unit = as.character(NA),
    region = character(),
    slice = character(),
    defVal = 0.,
    weather = data.frame(),
    ...) {
  .data2slots("weather",
              name,
              desc = desc,
              unit = unit,
              region = region,
              slice = slice,
              defVal = defVal,
              weather = weather,
              ...)
}


#' @param object object of class export
#'
#' @param ... slot-names with data to update (see `newWeather`)
#'
#' @rdname newTechnology
#' @family update weather
#' @method update weather
#' @export
setMethod("update", "weather", function(object, ...) {
  .data2slots("weather", object, ...)
})

