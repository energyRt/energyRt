# region
setClass("region",
      representation(
      # General information
          name          = "character",      # Short name
          description   = "character",      # Details
          type	        = "character",      # energy, electricity, material, (fuel?)
          color         = "character",      #
          sp            = "SpatialPolygonsDataFrame"              # Spatial 
      ),
      prototype(
          name          = "",
          description   = "",
          type	        = "",
          color         = "",
          sp            = NULL
      ),
      S3methods = TRUE
)

