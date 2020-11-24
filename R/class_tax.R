#' An S4 class to represent a commodity tax
#'
#' @slot name character. 
#' @slot comm character. 
#' @slot description character. 
#' @slot region character. 
#' @slot year numeric. 
#' @slot slice character. 
#' @slot defVal numeric. 
#' @slot value data.frame. 
#' @slot misc list. 
#'
#' @return
#' @export
#'
#' @examples
#' 
# !!! add slot "tax" = data.frame(comm, year, slice, tax)
# !!! add slot @variable = factor("output", "balance")
setClass("tax",
         representation(
           # General information
           name          = "character",      # Short name
           description   = "character",      # Details
           comm          = "character",      # 
           region        = "character",      #
           defVal        = "numeric",      # 
           tax           = "data.frame",      # 
           misc          = "list"
         ),
         prototype(
           name          = "",      # Short name
           comm          = "",
           description   = "",
           region        = character(),      #
           defVal        = 0,      # 
           tax = data.frame(
           	region = character(), 
           	year = numeric(), 
           	slice = character(), 
           	inp = numeric(), 
           	out = numeric(), 
           	bal = numeric(),
           	stringsAsFactors = FALSE),
           #! Misc
           misc = list()),
         S3methods = TRUE
)

#' An S4 class to represent a commodity sunsidy
#'
#' @slot name character. 
#' @slot description character. 
#' @slot comm character. 
#' @slot region character. 
#' @slot defVal numeric. 
#' @slot value data.frame. 
#' @slot misc list. 
#'
#' @return
#' @export
#'
#' @examples
#' 
# !!! add slot "sub" = data.frame(comm, year, slice, sub)
# !!! rename sub -> subsidy
# !!! add slot @variable = factor("output", "balance")
setClass("sub",
         representation(
           # General information
           name          = "character",      # Short name
           description   = "character",      # Details
           comm          = "character",      # 
           region        = "character",      #
           defVal        = "numeric",      # 
           sub          = "data.frame",      # 
           misc          = "list"
         ),
         prototype(
           name          = "",      # Short name
           comm          = "",
           description   = "",
           region        = character(),      #
           defVal        = 0,      # 
           sub = data.frame(
           	region = character(), 
           	year = numeric(), 
           	slice = character(), 
           	inp = numeric(), 
           	out = numeric(), 
           	bal = numeric(),
           	stringsAsFactors = FALSE),
           #! Misc
           misc = list()),
         S3methods = TRUE

)




