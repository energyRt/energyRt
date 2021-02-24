#' An S4 class to represent a supply of a commodity
#'
#' @slot name character. 
#' @slot description character. 
#' @slot commodity character. 
#' @slot unit character. 
#' @slot weather data.table. 
#' @slot reserve data.table. 
#' @slot availability data.table. 
#' @slot region character. 
#' @slot slice character. 
#' @slot misc list. 
#'
#' @return
#' @export
#'
#' @examples
setClass("supply",
      representation(
          name          = "character",
          description   = "character",
          # color         = "data.table",      #
          commodity     = "character",
          unit          = "character",
          weather       = "data.table", # weather factor (availability multiplier)
          reserve       = "data.table",         # Total available resource
          availability  = "data.table",     # Availability of the resource with prices
          region        = "character",
          # GIS                = "GIS", # @GIS # setClassUnion("GIS", members=c("SpatialPolygonsDataFrame", "NULL"))
          slice         = "character",
          misc = "list"
      ),
      prototype(
          name          = "",
          description   = "",
          # color         = data.table(region   = character(),
          #                            color    = character(),
          #                            stringsAsFactors = FALSE),
          commodity     = "",
          unit          = "",
          weather       = data.table(weather = character(), # name of the weather object
                                     wava.lo   = numeric(), # multipliers for ava.*, 1 by default
                                     wava.up   = numeric(),
                                     wava.fx   = numeric(),
                                     stringsAsFactors = FALSE),
          reserve       = data.table(region   = character(), # Total available resource by region
                                     res.lo   = numeric(),
                                     res.up   = numeric(),
                                     res.fx   = numeric(),
                                     stringsAsFactors = FALSE),
          availability  = data.table(region   = character(),
                                     year     = numeric(),
                                     slice    = character(),
                                     ava.lo   = numeric(),
                                     ava.up   = numeric(),
                                     ava.fx   = numeric(),
                                     cost     = numeric(),
                                     stringsAsFactors = FALSE),
        region = character(),
        # GIS           = NULL,
        slice         = character(),
        #! Misc
        misc = list()),
      S3methods = TRUE
)

setMethod("initialize", "supply", function(.Object, ...) {.Object})
