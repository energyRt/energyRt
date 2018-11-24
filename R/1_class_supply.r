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
          reserve       = "data.frame",         # Total available resource
          availability  = "data.frame",     # Availability of the resource with prices
          region        = "characterOrNULL",
          GIS                = "GIS", # @GIS # setClassUnion("GIS", members=c("SpatialPolygonsDataFrame", "NULL"))
          slice         = "characterOrNULL",
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
        region = NULL,
        GIS           = NULL,
        slice         = NULL,
        #! Misc
        misc = list(
        )),
      S3methods = TRUE
);
setMethod("initialize", "supply", function(.Object, ...) {
  attr(.Object, 'GUID') <- '75321e73-f425-4d45-a36c-72dc4a769a28'
  .Object
})
                                              