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
  attr(.Object, 'GUID') <- '4922cf26-c2e9-40c8-84bf-9a2fac4243e8'
  .Object
})
                                              
