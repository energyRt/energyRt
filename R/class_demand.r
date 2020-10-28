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
          dem           = "data.frame",      # Availability of the resource with prices 
          region         = "character",      # Availability of the resource with prices 
          # GIS                = "GIS", # 
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
          region         = character(),      # Availability of the resource with prices 
          dem           = data.frame(region   = character(),
                                     year     = integer(),
                                     slice    = character(),
                                     dem      = numeric(),
                                     stringsAsFactors = FALSE),
      #! Misc
      # GIS           = NULL,
      misc = list()),
      S3methods = TRUE
);
setMethod("initialize", "demand", function(.Object, ...) {
  .Object
})
             
