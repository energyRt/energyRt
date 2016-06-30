##---------------------------------------------------------------------------------------------------------
## row
##---------------------------------------------------------------------------------------------------------
#setClass("row",
#      representation(
#          name          = "character",
#          type          = "factor",
#          description   = "character",
#          color         = "data.frame",      #
#          commodity     = "character",
#          unit          = "character",
#          reserve       = "numeric",        
#          rowrs  = "data.frame",      
#          rowr   = "data.frame",      
#          rowy   = "data.frame"      
#          row    = "data.frame"      
#      ),
#      prototype(
#          name          = "",
#          type          = factor('Demand', levels = c('Demand', 'Supply')),
#          description   = "",
#          color         = data.frame(region   = character(),
#                                     color    = character(),
#                                     stringsAsFactors = FALSE),
#          commodity     = "",
#          unit          = "",
#          reserve       = Inf,         # Total available resource
#          rowrs  = data.frame(region   = character(),
#                                     year     = numeric(),
#                                     slice    = character(),
#                                     rowrs.lo   = numeric(),
#                                     rowrs.up   = numeric(),
#                                     rowrs.fx   = numeric(),
#                                     cost     = numeric(),
#                                     stringsAsFactors = FALSE),
#          rowr   = data.frame(region   = character(),
#                                     year     = numeric(),
#                                     rowr.lo   = numeric(),
#                                     rowr.up   = numeric(),
#                                     rowr.fx   = numeric(),
#                                     stringsAsFactors = FALSE),
#          rows   = data.frame(region   = character(),
#                                     year     = numeric(),
#                                     slice    = character(),
#                                     rows.lo   = numeric(),
#                                     rows.up   = numeric(),
#                                     rows.fx   = numeric(),
#                                     stringsAsFactors = FALSE),
#          row    = data.frame(
#                                     year     = numeric(),
#                                     row.lo   = numeric(),
#                                     row.up   = numeric(),
#                                     row.fx   = numeric(),
#                                     stringsAsFactors = FALSE),
#      ),
#      S3methods = TRUE
#);
