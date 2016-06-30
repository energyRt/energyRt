# region
setClass("region",
      representation(
      # General information
          name          = "character",      # Short name
          description   = "character",      # Details
          type	        = "character",      # energy, electricity, material, (fuel?)
          color         = "character"       #
      ),
      prototype(
          name          = "",
          description   = "",
          type	        = "",
          color         = ""
      ),
      S3methods = TRUE
)

