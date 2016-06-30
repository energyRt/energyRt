#---------------------------------------------------------------------------------------------------------
# Model
#---------------------------------------------------------------------------------------------------------
if (!isClass('precompiled')) setClassUnion("precompiled")
#source('r/class_sysInfo.r')
setClass("model",
      representation(
          name           = "character",
          description    = "character",       # Details
          data           = "list",
          sysInfo        = "sysInfo",
          codeProduce    = "CodeProduce", 
          additionalCode = "character",
          additionalCodeAfter = "character",
          LECdata        = "list",
          early.retirement = "logical"
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
          early.retirement = TRUE
      ),                           
      S3methods = TRUE
);

