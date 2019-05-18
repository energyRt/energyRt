# region
setClass("region",
      representation(
      # General information
          name          = "character",      # Short name
          description   = "character",      # Details
          type	        = "character",      # energy, electricity, material, (fuel?)
          color         = "character",      #
          sp            = "SpatialPolygonsDataFrame",              # Spatial 
          misc = "list"
      ),
      prototype(
          name          = "",
          description   = "",
          type	        = "",
          color         = "",
          sp            = NULL,
      #! Misc
      misc = list(
      )),
      S3methods = TRUE
)
setMethod("initialize", "region", function(.Object, ...) {
  .Object
})
                                              
