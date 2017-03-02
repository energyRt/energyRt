#---------------------------------------------------------------------------------------------------------
# export
#---------------------------------------------------------------------------------------------------------
setClass("export",
      representation(
          name          = "character",
          description   = "character",
          color         = "data.frame",      #
          commodity     = "character",
          unit          = "character",
          reserve       = "numeric",
          exp           = "data.frame",
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
          reserve       = Inf,
          exp           = data.frame(region   = character(),
                                     year     = numeric(),
                                     slice    = character(),
                                     exp.lo   = numeric(),
                                     exp.up   = numeric(),
                                     exp.fx   = numeric(),
                                     price     = numeric(),
                                     stringsAsFactors = FALSE),
      #! Misc
      misc = list(
        GUID = "cbeee0e8-4f3b-4c79-8765-fbae9fd7578e"
      )),
      S3methods = TRUE
);
