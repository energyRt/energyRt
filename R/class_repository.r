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
  attr(.Object, 'GUID') <- 'd8433f44-c3c6-42fd-ae89-780e4e8b7329'
  .Object
})
                                              


