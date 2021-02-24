#---------------------------------------------------------------------------------------------------------
# weather
#---------------------------------------------------------------------------------------------------------
setClass("weather",
         representation(
           name          = "character",
           description   = "character",
           unit          = "character",
           region        = "character",
           slice         = "character",
           defVal        = "numeric",
           weather       = "data.table", # weather factor (availability multiplier)
           # color         = "data.table",      #
           misc = "list"
         ),
         prototype(
           name          = "",
           description   = "",
           unit          = as.character(NA),
           region        = character(),
           slice         = character(),
           defVal        = 0.,
           weather       = data.table(region   = character(), # 
                                      year     = numeric(),
                                      slice    = character(),
                                      wval     = numeric(),
                                      stringsAsFactors = FALSE),
           # color         = data.table(region   = character(),
           #                            slice    = character(),
           #                            color    = character(),
           #                            stringsAsFactors = FALSE),
           #! Misc
           misc = list()),
         S3methods = TRUE
);
setMethod("initialize", "weather", function(.Object, ...) {
  .Object
})
