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
          slice         = "character",
          GIS                = "GIS", # @GIS # setClassUnion("GIS", members=c("SpatialPolygonsDataFrame", "NULL"))
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
      GIS           = NULL,
      slice         = character(),
      #! Misc
      misc = list(
      )),
      S3methods = TRUE
);
setMethod("initialize", "export", function(.Object, ...) {
  .Object
})
