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
      misc = list(
        additionalCode = "",        # move 2 misc
        additionalCodeAfter = ""   # move 2 misc
      )),                           
      S3methods = TRUE
)
setMethod("initialize", "model", function(.Object, ...) {
  attr(.Object, 'GUID') <- 'e4be2c7e-8ddf-4952-8f27-8fd12ca79e78'
  .Object
})
             
