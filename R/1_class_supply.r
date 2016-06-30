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
          reserve       = "numeric",         # Total available resource
          availability  = "data.frame"      # Availability of the resource with prices
      ),
      prototype(
          name          = "",
          description   = "",
          color         = data.frame(region   = character(),
                                     color    = character(),
                                     stringsAsFactors = FALSE),
          commodity     = "",
          unit          = "",
          reserve       = Inf,         # Total available resource
          availability  = data.frame(region   = character(),
                                     year     = numeric(),
                                     slice    = character(),
                                     ava.lo   = numeric(),
                                     ava.up   = numeric(),
                                     ava.fx   = numeric(),
                                     cost     = numeric(),
                                     stringsAsFactors = FALSE)
      ),
      S3methods = TRUE
);
