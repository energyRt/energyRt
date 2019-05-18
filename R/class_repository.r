#---------------------------------------------------------------------------------------------------------
# Repository : technology
#---------------------------------------------------------------------------------------------------------
setClass("repository",
      representation(
          name          = "character",
          description   = "character",       # Details
          data          = "list",
          GIS                = "GIS", # @GIS # setClassUnion("GIS", members=c("SpatialPolygonsDataFrame", "NULL"))
          misc = "list"
      ),
      prototype(
          name          = "default_repository",
          description   = "",       # Details
          data          = list(),
      GIS           = NULL,
      #! Misc
      misc = list(
      )),
      S3methods = TRUE
);
setMethod("initialize", "repository", function(.Object, ...) {
  .Object
})
                                              


