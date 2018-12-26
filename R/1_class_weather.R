#---------------------------------------------------------------------------------------------------------
# weather
#---------------------------------------------------------------------------------------------------------
setClass("weather",
         representation(
           name          = "character",
           description   = "character",
           unit          = "character",
           region        = "characterOrNULL",
           slice         = "characterOrNULL",
           weather       = "data.frame", # weather factor (availability multiplier)
           color         = "data.frame",      #
           misc = "list"
         ),
         prototype(
           name          = "",
           description   = "",
           unit          = as.character(NA),
           region = NULL,
           slice         = NULL,
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
  attr(.Object, 'GUID') <- '98271d3b-9704-42c2-8748-9fd1b3760eba'
  .Object
})
