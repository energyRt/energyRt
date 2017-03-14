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
          codeProduce    = "CodeProduce", 
          additionalCode = "character",        # move 2 misc
          additionalCodeAfter = "character",   # move 2 misc
          LECdata        = "list",
          early.retirement = "logical",
          misc = "list"
      ),
      prototype(
          name           = "",
          description    = "",       # Details
          data           = list(),
          sysInfo        = new('sysInfo'),
          codeProduce    = NULL,
          additionalCode = "",
          additionalCodeAfter = "",
          LECdata        = list(),
          early.retirement = FALSE,
      #! Misc
      misc = list(
        GUID = "e4be2c7e-8ddf-4952-8f27-8fd12ca79e78"
      )),                           
      S3methods = TRUE
);

