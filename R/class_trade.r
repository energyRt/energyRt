setClass("trade",
      representation(
      # General information
          name          = "character",       # Short name
          description   = "character",       # Details
          commodity     = "character",       # Vector if NULL that
          source        = "characterOrNULL",       # if NULL that in all region
          destination   = "characterOrNULL",       # if NULL that in all region
      # Performance parameters
          trade         = "data.frame",
          aux           = "data.frame",      #
          aeff         = "data.frame",    #  Commodity efficiency
          GIS                = "GIS", # @GIS # setClassUnion("GIS", members=c("SpatialPolygonsDataFrame", "NULL"))
          # slice = "characterOrNULL", # imported from commodity
          misc = "list"
      ),
      # Default values and structure of slots
      prototype(
      # General information
         name           = "default_trade",       # Short name
         description    = "",
         commodity      = NULL,       #
         source         = character(),
         destination    = character(),
         trade          = data.frame(
                                     src        = character(),
                                     dst        = character(),
                                     year       = numeric(),
                                     slice      = character(),
                                     ava.up     = numeric(),
                                     ava.fx     = numeric(),
                                     ava.lo     = numeric(),
                                     cost       = numeric(),
                                     markup     = numeric(),
                                     csrc2cdst  = numeric(),
                                     stringsAsFactors = FALSE),
         aux           = data.frame(acomm     = character(),
                                    unit     = character(),
                                    stringsAsFactors = FALSE),
         # Auxilary parameter
         aeff          = data.frame(
                                     acomm      = character(),
                                     src     = character(),
                                     dst     = character(),
                                     year       = numeric(),
                                     slice      = character(),
                                     ainp  = numeric(),
                                     aout  = numeric(),
                                     stringsAsFactors = FALSE),
        GIS           = NULL,
        # slice = NULL,
        #! Misc
        misc = list(
        )),
      S3methods = TRUE
);
setMethod("initialize", "trade", function(.Object, ...) {
  attr(.Object, 'GUID') <- '97e0ed37-fc8a-4210-ad95-702cf75bed56'
  .Object
})
