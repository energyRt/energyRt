# Tax on commodity
setClass("tax",
         representation(
           # General information
           comm          = "character",      # Short name
           description   = "character",      # Details
           region        = "character",      #
           year          = "numeric",      #
           slice         = "character",      #
           value         = "data.frame",      # 
           misc = "list"
         ),
         prototype(
           comm          = "",
           description   = "",
           region        = character(),      #
           year          = numeric(),      #
           slice         = character(),      #
           value        = data.frame(stringsAsFactors = FALSE),
           #! Misc
           misc = list(
           )),
         S3methods = TRUE
)

# Subs on commodity
setClass("subs",
         representation(
           # General information
           comm          = "character",      # Short name
           description   = "character",      # Details
           region        = "character",      #
           year          = "numeric",      #
           slice         = "character",      #
           value         = "data.frame",      # 
           misc = "list"
         ),
         prototype(
           comm          = "",
           description   = "",
           region        = character(),      #
           year          = numeric(),      #
           slice         = character(),      #
           value        = data.frame(stringsAsFactors = FALSE),
           #! Misc
           misc = list(
           )),           #! Misc
         S3methods = TRUE
)




