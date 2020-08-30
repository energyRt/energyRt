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
           weather       = "data.frame", # weather factor (availability multiplier)
           color         = "data.frame",      #
           misc = "list"
         ),
         prototype(
           name          = "",
           description   = "",
           unit          = as.character(NA),
           region        = character(),
           slice         = character(),
           defVal        = 0.,
           weather       = data.frame(region   = character(), # 
                                      year     = numeric(),
                                      slice    = character(),
                                      wval     = numeric(),
                                      stringsAsFactors = FALSE),
           color         = data.frame(region   = character(),
                                      slice    = character(),
                                      color    = character(),
                                      stringsAsFactors = FALSE),
           #! Misc
           misc = list(
           )),
         S3methods = TRUE
);
setMethod("initialize", "weather", function(.Object, ...) {
  .Object
})
