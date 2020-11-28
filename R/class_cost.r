#---------------------------------------------------------------------------------------------------------
# equation
#---------------------------------------------------------------------------------------------------------
#' Class 'cost'
#'
#' @slot name character. 
#' @slot description character. 
#' @slot for.sum data.frame. 
#' @slot variable character. 
#' @slot mult data.frame. 
#' @slot misc list. 
#'
setClass('cost', 
         representation(
           name          = "character",
           description   = "character",       # description
           for.each      = "data.frame",
           for.sum       = "data.frame",
           variable      = "character",
           mult          = "data.frame",
           defVal        = "numeric",
           misc = "list"
           # parameter= list() # For the future
         ),
         prototype(
           name          = NULL,
           description   = '',       # description
           for.each      = data.frame(),
           for.sum       = data.frame(),
           variable      = character(),
           mult          = data.frame(),
           defVal        = 1,
           #! Misc
           misc = list(
           )),
         S3methods = TRUE
);
setMethod("initialize", "cost", function(.Object, ...) {
  .Object
})


 

