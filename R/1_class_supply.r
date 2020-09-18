#---------------------------------------------------------------------------------------------------------
# supply
#---------------------------------------------------------------------------------------------------------
setClass("supply",
      representation(
          name          = "character",
          description   = "character",
          color         = "data.frame",      #
          commodity     = "character",
          unit          = "character",
          weather       = "data.frame", # weather factor (availability multiplier)
          reserve       = "data.frame",         # Total available resource
          availability  = "data.frame",     # Availability of the resource with prices
          region        = "character",
          GIS                = "GIS", # @GIS # setClassUnion("GIS", members=c("SpatialPolygonsDataFrame", "NULL"))
          slice         = "character",
          misc = "list"
      ),
      prototype(
          name          = "",
          description   = "",
          color         = data.frame(region   = character(),
                                     color    = character(),
                                     stringsAsFactors = FALSE),
          commodity     = "",
          unit          = "",
          weather       = data.frame(weather = character(), # name of the weather object
                                     wava.lo   = numeric(), # multipliers for ava.*, 1 by default
                                     wava.up   = numeric(),
                                     wava.fx   = numeric(),
                                     stringsAsFactors = FALSE),
          reserve       = data.frame(region   = character(), # Total available resource by region
                                     res.lo   = numeric(),
                                     res.up   = numeric(),
                                     res.fx   = numeric(),
                                     stringsAsFactors = FALSE),
          availability  = data.frame(region   = character(),
                                     year     = numeric(),
                                     slice    = character(),
                                     ava.lo   = numeric(),
                                     ava.up   = numeric(),
                                     ava.fx   = numeric(),
                                     cost     = numeric(),
                                     stringsAsFactors = FALSE),
        region = character(),
        GIS           = NULL,
        slice         = character(),
        #! Misc
        misc = list(
        )),
      S3methods = TRUE
);
setMethod("initialize", "supply", function(.Object, ...) {
  .Object
})
