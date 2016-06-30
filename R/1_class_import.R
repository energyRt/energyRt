#---------------------------------------------------------------------------------------------------------
# import
#---------------------------------------------------------------------------------------------------------
setClass("import",
      representation(
          name          = "character",
          description   = "character",
          color         = "data.frame",      #
          commodity     = "character",
          unit          = "character",
          reserve       = "numeric",
          imp           = "data.frame"
      ),
      prototype(
          name          = "",
          description   = "",
          color         = data.frame(region   = character(),
                                     color    = character(),
                                     stringsAsFactors = FALSE),
          commodity     = "",
          unit          = "",
          reserve       = Inf,
          imp           = data.frame(region   = character(),
                                     year     = numeric(),
                                     slice    = character(),
                                     imp.lo   = numeric(),
                                     imp.up   = numeric(),
                                     imp.fx   = numeric(),
                                     price     = numeric(),
                                     stringsAsFactors = FALSE)
      ),
      S3methods = TRUE
);
