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
setClass('constraint', 
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


 
newCost <- function(name, variable, description = '', mult = NULL, for.each = NULL, for.sum = NULL, defVal = 0) {
  obj <- new('cost')
  obj@name <- name
  obj@description <- description
  
  # Add for.each
  if (!is.null(for.each)) {
    if (is.list(for.each) && !is.data.frame(for.each)) {
      for.each2 <- data.frame(stringsAsFactors = FALSE)
      for (i in names(for.each)) {
        if (is.null(for.each[[i]])) for.each[[i]] <- NA
        for.each2[[i]] <- for.each[[i]]
      }
      for.each <- for.each2
    }
    if (is.data.frame(for.each)) {
      if (all(colnames(for.each) %in% c('region', 'year'))) 
        stop(paste0('There are unknown columns in for.each "', 
                    paste0(colnames(for.each)[!(colnames(for.each) %in% c('region', 'year'))], collapse = '", "'), 
                    '", in cost "', name, '".'))
    } else stop(paste0('Unknown type for.each in cost "', name, '".'))
  } else {
    for.each <- data.frame(region = NA, year = NA, stringsAsFactors = FALSE)
  }
  obj@for.each <- for.each

  # Add variable
  sets <- getVariablesSet()[variable]
  if (is.null(sets))
        stop(paste0('There are unknown variable "', variable, '" in cost "', name, '".'))
  if (anyDuplicated(sets))
        stop(paste0('Add cost to variable with duplicated sets is not allowed now (cost "', name, '").'))
  if (sum(!(sets %in% c('region', 'year'))))
        stop(paste0('Add cost to variable without setS region & YEAR is not allowed (cost "', name, '").'))
  obj@variable <- variable
  sets_for.sum <- sets[!(sets %in% c('region', 'year'))]
  
  # Add for.sum
  if (!is.null(for.sum)) {
    if (is.list(for.sum) && !is.data.frame(for.sum)) {
      for.sum2 <- data.frame(stringsAsFactors = FALSE)
      for (i in names(for.sum)) {
        if (is.null(for.sum[[i]])) for.sum[[i]] <- NA
        for.sum2[[i]] <- for.sum[[i]]
      }
      for.sum <- for.sum2
    }
    if (is.data.frame(for.sum)) {
      if (!all(colnames(for.sum) %in% sets_for.sum))
        stop(paste0('There are unknown columns in for.sum "', 
                    paste0(colnames(for.sum)[!(colnames(for.sum) %in% sets_for.sum)], collapse = '", "'), 
                    '", in cost "', name, '".'))
    } else stop(paste0('Unknown type for.sum in cost "', name, '".'))
  }
  obj@for.sum <- for.sum
  
  # Add mult
  if (is.numeric(mult)) obj@defVal <- mult else {
   if (is.data.frame(mult)) {
      if (!all(colnames(mult) %in% sets))
        stop(paste0('There are unknown columns in mult "', 
                    paste0(mult[!(mult %in% sets)], collapse = '", "'), 
                    '", in cost "', name, '".'))
    } else stop(paste0('Unknown type mult in cost "', name, '".'))
    mult <- mult[, sapply(mult, function(x) any(!is.na(x))), drop = FALSE]
    if (!is.null(mut$value))
       stop(paste0('There is not column value in cost "', name, '".'))
    if (anyDuplicated(mult[, colnames(mult) != 'value', drop = FALSE]) || (ncol(mult) == 1 && nrow(mult) != 1)) 
        stop(paste0('There duplcated value in mult (cost "', name, '").'))
   if (ncol(mult) == 1) obj@defVal <- mult$value else obj@mult <- mult
  }
   obj
}
    
    

