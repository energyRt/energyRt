#---------------------------------------------------------------------------------------------------------
# Model
#---------------------------------------------------------------------------------------------------------
#source('r/class_sysInfo.r')
setClass("model",
      representation(
          name           = "character",
          description    = "character",       # Details
          data           = "list",
          sysInfo        = "sysInfo",
          modInp         = "modInp", 
          LECdata        = "list",
          early.retirement = "logical",
          misc = "list"
      ),
      prototype(
          name           = "",
          description    = "",       # Details
          data           = list(),
          sysInfo        = new('sysInfo'),
          modInp         = NULL,
          LECdata        = list(),
          early.retirement = FALSE,
      #! Misc
      misc = list()),                           
      S3methods = TRUE
)
setMethod("initialize", "model", function(.Object, ...) {
  .Object
})
             
