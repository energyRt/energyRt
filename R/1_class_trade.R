##---------------------------------------------------------------------------------------------------------
## trade
##---------------------------------------------------------------------------------------------------------
#setClass("trade",
#      representation(
#          name          = "character",
#          description   = "character",
#          color         = "data.frame",      #
#          commodity     = "character",
#          unit          = "character",
#          availability  = "data.frame"      # 
#      ),
#      prototype(
#          name          = "",
#          description   = "",
#          color         = data.frame(region   = character(),
#                                     color    = character(),
#                                     stringsAsFactors = FALSE),
#          commodity     = "",
#          unit          = "",
#          availability  = data.frame(region   = character(),
#                                     year     = numeric(),
#                                     slice    = character(),
#                                     ava.lo   = numeric(),
#                                     ava.up   = numeric(),
#                                     ava.fx   = numeric(),
#                                     cost     = numeric(),
#                                     stringsAsFactors = FALSE)
#      ),
#      S3methods = TRUE
#);
