#---------------------------------------------------------------------------------------------------------
# equation
#---------------------------------------------------------------------------------------------------------
#' Class 'costs'
#'
#' @slot name character. 
#' @slot description character. 
#' @slot variable character. 
#' @slot subset data.table. 
#' @slot mult data.table. 
#' @slot misc list. 
#'
setClass('costs', 
         representation(
           name          = "character",
           description   = "character",       # description
           variable      = "character",
           subset        = "data.table",
           mult          = "data.table",
           misc = "list"
           # parameter= list() # For the future
         ),
         prototype(
           name          = NULL,
           description   = '',       # description
           variable      = character(),
           subset        = data.table(),
           mult          = data.table(),
           #! Misc
           misc = list(
           )),
         S3methods = TRUE
);
setMethod("initialize", "costs", function(.Object, ...) {
  .Object
})


 
newCosts <- function(name, variable, description = '', mult = NULL, subset = NULL) {
  obj <- new('costs')
  obj@name <- name
  obj@description <- description
  
  # Add variable
  sets <- energyRt:::.variable_set[[variable]]
  if (is.null(sets))
        stop(paste0('There are unknown variable "', variable, '" in cost "', name, '".'))
  # if (anyDuplicated(sets))
  #       stop(paste0('Add cost to variable with duplicated sets is not allowed now (cost "', name, '").'))
  if (anyDuplicated(sets))
    sets[duplicated(sets)] <- paste0(sets[duplicated(sets)], 2)
  if (sum(sets %in% c('region', 'year')) != 2)
        stop(paste0('Add cost to variable without sets region & year is not allowed (cost "', name, '").'))
  obj@variable <- variable

   # Add subset
  if (!is.null(subset)) {
    if (is.list(subset) && !is.data.table(subset)) {
      subset2 <- data.table()
      for (i in names(subset)) if (!is.null(subset[[i]])) {
        subset2[[i]] <- subset[[i]]
      }
      subset <- subset2
    }
    if (!all(colnames(subset) %in% sets)) {
      bug <- colnames(subset)[!(colnames(subset) %in% sets)]
      stop(paste0('There ', c('is', 'are')[1 + length(bug) != 1], ' unnecessary column', 
          's'[length(bug) != 1], ' "', paste0(bug, collapse = '", "'), '" in subset (cost "', name, '").'))
    }
    if (!is.data.table(subset)) 
      stop(paste0('Subset have to be list or data.table (cost "', name, '").'))
    if (anyDuplicated(subset)) 
      stop(paste0('There are duplicated row(s) in subset (cost "', name, '").'))
    subset <- subset[, !apply(is.na(subset), 2, all), drop = FALSE]
    obj@subset <- subset
  }

 # Add mult
  if (!is.null(mult)) {
    if (!is.data.table(mult) && !is.numeric(mult))
      stop(paste0('Mult have to be numeric or data.table (cost "', name, '").'))
    if (is.numeric(mult)) {
      obj@mult <- data.table(value = mult)
    } else {
      if (!all(colnames(mult) %in% c('value', sets))) {
        bug <- colnames(mult)[!(colnames(mult) %in% c('value', sets))]
        stop(paste0('There ', c('is', 'are')[1 + length(bug) != 1], ' unnecessary column', 
            's'[length(bug) != 1], ' "', paste0(bug, collapse = '", "'), '" in mult (cost "', name, '").'))
      }
      mult <- mult[, !apply(is.na(mult), 2, all), drop = FALSE]
      if (anyDuplicated(mult[, colnames(mult) != 'value', drop = FALSE])) 
        stop(paste0('There are duplicated row(s) in mult (cost "', name, '").'))
      if (is.null(mult$value)) 
        stop(paste0('There is not value in mult (cost "', name, '").'))
      # Remove unused set values from mult (by subset)
      if (any(colnames(mult) %in% colnames(subset))) {
        for (ss in colnames(mult)[colnames(mult) %in% colnames(subset)]) {
          mult <- mult[is.na(mult[[ss]]) | mult[[ss]] %in% 
                         unique(subset[[ss]][!is.na(subset[[ss]])]),, drop = FALSE]
        }
      }
      if (ncol(mult) > 1) obj@mult <- mult else obj@defVal <- mult$value
    }
  }
  if (nrow(obj@mult) == 0 && obj@defVal == 0) 
    warning(paste0('The cost of the "', name, '" is strictly equal to zero.'))

  obj
}
    
    
# Calculate do equation need additional set, and add it
.getCostEquation <- function(prec, stm, approxim) {
  stop.constr <- function(x) 
    stop(paste0('Cost "', stm@name, '" error: ', x))
  get.all.child <- function(x)  {
    unique(c(x, c(approxim$slice@all_parent_child[approxim$slice@all_parent_child$parent %in% x, 'child'])))
  }
  have.all.set <- function(x, name)  {
    return (any(is.na(x)) || (name != 'slice' && all(approxim[[name]] %in% x)))
  }
  sets <- energyRt:::.variable_set[[stm@variable]]
  if (anyDuplicated(energyRt:::.variable_set[[stm@variable]])) {
    dsets <- sets[duplicated(sets)]
    for (dst in dsets)
      approxim[[paste0(dst, 2)]] <- approxim[[dst]]
    sets[duplicated(sets)] <- paste0(sets[duplicated(sets)], 2)
  }
  # Generate mult
  if (nrow(stm@mult) != 0) {
    # browser()
    approxim2 <- approxim[unique(c(colnames(stm@mult)[colnames(stm@mult) %in% names(approxim)], 'fullsets', 'solver', 'year'))]
    if (!is.null(approxim2$slice)) approxim2$slice <- approxim2$slice@all_slice
    if (!is.null(approxim2$slice2)) approxim2$slice2 <- approxim2$slice@all_slice2
    if (nrow(stm@subset) != 0) {
      same <- colnames(stm@subset)[colnames(stm@subset) %in% colnames(stm@mult)]
      same <- same[!apply(is.na(stm@subset[, same, drop = FALSE]), 2, any)]
      for (ss in same)
        approxim2[[ss]] <- unique(stm@subset[[ss]][!is.na(stm@subset[[ss]])])
    }
    mult_sets <- colnames(stm@mult)[colnames(stm@mult) != 'value']
    for (ss in mult_sets)
      stm@mult <- stm@mult[stm@mult[[ss]] %in% approxim2[[ss]],, drop = FALSE]
    xx <- newParameter(paste0('pCosts', stm@name), mult_sets, 'simple', defVal = 0, 
                          interpolation = 'back.inter.forth', colName = 'value')
    yy <- simpleInterpolation(stm@mult, 'value', xx, approxim2)
    prec@parameters[[xx@name]] <- .add_data(xx, yy)
    sss <- ''
    if (length(mult_sets) != 0) sss <- paste0('(', paste0(mult_sets, collapse = '", "'), ')')
    mult_txt <- paste0(xx@name, sss,' * ')
  } else mult_txt <- paste0(stm@defVal, ' * ')

  # Generate subset
  if (nrow(stm@subset) != 0) {
    fl <- apply(!is.na(stm@subset), 1, all)
    subset <- stm@subset[fl,, drop = FALSE]
    approxim2 <- approxim[colnames(stm@subset)]
    if (!is.null(approxim2$slice)) approxim2$slice <- approxim2$slice@all_slice
    if (any(!fl)) {
      subset_na <- stm@subset[!fl,, drop = FALSE]
        for (i in seq_len(ncol(subset_na))[apply(is.na(subset_na), 2, any)]) {
          f2 <- is.na(subset_na[[i]])
          subset_na2 <- subset_na[fl,, drop = FALSE]
          subset_na3 <- subset_na2[0,,drop = FALSE]
          ncs <- approxim2[[colnames(subset_na)[i]]]
          subset_na3[nrow(subset_na2) * length(ncs), ] <- NA
          for (j in seq_len(ncol(subset_na))[seq_len(ncol(subset_na)) != i]) 
            subset_na3[, j] <- subset_na3[[j]]
          subset_na3[, j] <- c(matrix(ncs, nrow(subset_na3), length(ncs), byrow = TRUE))
          subset_na <- unique(rbind(subset_na[!fl,, drop = FALSE], subset_na3))
        }
      subset <- rbind(subset, subset_na)
    }
    for (ss in colnames(subset))
      subset <- subset[subset[[ss]] %in% approxim2[[ss]],, drop = FALSE]
    
    xnm <- paste0('mCosts', stm@name)
    prec@parameters[[xnm]] <- .add_data(newParameter(xnm, colnames(subset), 'map'), subset)
    subset_txt <- paste0(xnm, '(', paste0(colnames(subset), collapse = ', '), ')')
  } else subset_txt <- NULL
  
  # Generate equation text
  mps <- energyRt:::.variable_mapping[[stm@variable]]
  if (length(sets) == 2) {
    if (is.null(subset_txt)) costs <- paste0(mult_txt, mps) else 
    if (any(grep('[$]', mps))) {
      costs <- paste0('(', mult_txt, gsub('[$].*', '', mps), ')$(', gsub('.*[$]', '', mps),
               ' and ', subset_txt,')')
    } else costs <- paste0('(', mult_txt, mps, '$', subset_txt)
  } else {
    nset <- sets[!(sets %in% c('region', 'year'))]
    if (length(nset) != 1) nset <- paste0('(', paste0(nset, collapse = ', '), ')')
    mps <- gsub('[(][^(]*[)]', paste0('( ', paste0(sets, collapse = ' , '), ' )'), mps)
    nkk <- c(gsub('.*[$]', '', mps), subset_txt)
    if (length(nkk) != 1) nkk <- paste0('(', paste0(nkk, collapse = ' and '), ')')
    costs <- paste0('sum(', nset, '$', nkk, ', ', mult_txt, gsub('[$].*', '', mps), ')')
  }
  costs <- gsub('[ ]*[*][ ]*', ' * ',  gsub('[)]and', ') and',  gsub('[ ]*[,][ ]*', ', ', gsub('[ ]*[)][ ]*', ')', 
      gsub('[ ]*[(][ ]*', '(', gsub('[+][ ]*[-]', '-', gsub('[ ]*[$][ ]*', '$', costs)))))))
  prec@costs.equation <- c(prec@costs.equation, costs)
  prec
}

#  .getSetEquation(prec, stm, approxim)@gams.equation


