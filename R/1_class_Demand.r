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
          dem           = "data.frame"      # Availability of the resource with prices
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
                                     stringsAsFactors = FALSE)
      ),
      S3methods = TRUE
);
