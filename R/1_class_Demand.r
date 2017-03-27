#---------------------------------------------------------------------------------------------------------
# Demand
#---------------------------------------------------------------------------------------------------------
setClass("demand",
      representation(
          name          = "character",
          description   = "character",
          color         = "data.frame",      #
          commodity     = "character",
          unit          = "character",
          dem           = "data.frame",      # Availability of the resource with prices 
          GIS                = "GIS", # @GIS # setClassUnion("GIS", members=c("SpatialPolygonsDataFrame", "NULL"))
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
          dem           = data.frame(region   = character(),
                                     year     = numeric(),
                                     slice    = character(),
                                     dem      = numeric(),
                                     stringsAsFactors = FALSE),
      #! Misc
      GIS           = NULL,
      misc = list(
      )),
      S3methods = TRUE
);
setMethod("initialize", "demand", function(.Object, ...) {
  attr(.Object, 'GUID') <- 'f4b613b2-1efc-4c51-983c-f776e85a0e9b'
  .Object
})
             