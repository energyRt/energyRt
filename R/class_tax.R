# Tax on commodity
setClass("tax",
         representation(
           # General information
           name          = "character",      # Short name
           comm          = "character",      # 
           description   = "character",      # Details
           region        = "character",      #
           year          = "numeric",      #
           slice         = "character",      #
           defVal        = "numeric",      # 
           value         = "data.frame",      # 
           misc = "list"
         ),
         prototype(
           name          = "",      # Short name
           comm          = "",
           description   = "",
           region        = character(),      #
           year          = numeric(),      #
           slice         = character(),      #
           defVal        = 0,      # 
           value        = data.frame(stringsAsFactors = FALSE),
           #! Misc
           misc = list(
           )),
         S3methods = TRUE
)

# Subs on commodity
setClass("sub",
         representation(
           # General information
           name          = "character",      # Short name
           comm          = "character",      # 
           description   = "character",      # Details
           region        = "character",      #
           year          = "numeric",      #
           slice         = "character",      #
           defVal        = "numeric",      # 
           value         = "data.frame",      # 
           misc = "list"
         ),
         prototype(
           name          = "",      # Short name
           comm          = "",
           description   = "",
           region        = character(),      #
           year          = numeric(),      #
           slice         = character(),      #
           defVal        = 0,      # 
           value        = data.frame(stringsAsFactors = FALSE),
           #! Misc
           misc = list()),           #! Misc
         S3methods = TRUE
)




