#---------------------------------------------------------------------------------------------------------
# equation
#---------------------------------------------------------------------------------------------------------
setClass('statement', 
         representation(
           name          = "character",
           description   = "character",       # description
           eq            = "factor",
           for.each      = "list",
           rhs           = "data.frame",
           defVal        = "numeric",
           lhs           = "list",
           misc = "list"
           # parameter= list() # For the future
         ),
         prototype(
           name          = NULL,
           description   = '',       # description
           eq            = factor('==', levels = c('>=', '<=', '==')),
           for.each      = list(),
           rhs           = data.frame(),
           defVal        = 0,
           lhs           = list(),
           #! Misc
           misc = list(
           )),
         S3methods = TRUE
);
setMethod("initialize", "statement", function(.Object, ...) {
  attr(.Object, 'GUID') <- 'b8b3c68c-8d82-4844-aff9-8b12ba6da878'
  .Object
})


#---------------------------------------------------------------------------------------------------------
# term for equation
#---------------------------------------------------------------------------------------------------------
setClass('summand', 
         representation(
           description   = "character",       # description
           variable      = "character",
           for.sum       = "list",
           mult          = "data.frame",
           defVal        = "numeric",
           misc = "list"
           # parameter= list() # For the future
         ),
         prototype(
           description   = NULL,       # description
           variable      = NULL,
           for.sum       = list(),
           mult          = data.frame(),
           defVal        = 1,
           #! Misc
           misc = list(
           )),
         S3methods = TRUE
);


newStatement <- function(name, eq = '==', rhs = data.frame(), for.each = list(), defVal = 0, ...) {
  obj <- new('statement')
  #stopifnot(length(eq) == 1 && eq %in% levels(obj@eq))
  if (length(eq) != 1 || !(eq %in% levels(obj@eq)))   {
    stop('Wrong condition type')
  }
  obj@eq[] <- eq
  if (is.numeric(rhs)) {
    defVal <- rhs
    rhs <- data.frame()
  }
  if (!is.data.frame(rhs) && is.list(rhs) && length(rhs) == 1 && length(rhs[[1]]) == 1) {
    defVal <- rhs[[1]]
    rhs <- data.frame()
  }
  if (is.data.frame(rhs) && ncol(rhs) == 1 && nrow(rhs) == 1) {
    defVal <- rhs[1, 1]
    rhs <- data.frame()
  }
  if (is.numeric(rhs)) {
    defVal <- rhs
    rhs <- data.frame()
  }
  if (!is.data.frame(rhs) && is.list(rhs)) {
    xx <- sapply(rhs, length)
    if (any(xx[1] != xx))
      stop(paste0('Wrong rhs parameters '))
    if (xx[1] >= 1) {
      xx <- data.frame(stringsAsFactors = FALSE)
      xx[seq_len(length(rhs[[1]])), ] <- NA
      for (i in names(rhs)) xx[, i] <- rhs[[i]]
      rhs <- xx
    }
  }
  # TYPE vs SET   
  obj@rhs       <- rhs
  obj@defVal    <- defVal
  obj@name      <- name
  obj@for.each  <- for.each
  arg <- list(...)
  for (i in seq_along(arg)) {
    obj <- addSummand(obj, arg = arg[[i]])
  }
  obj
}


addSummand <- function(eqt, variable = NULL, mult = data.frame(), for.sum = list(), arg) {
  if (!is.null(names(arg))) {
    if (any(names(arg) == 'variable')) variable <- arg$variable
    if (any(names(arg) == 'mult')) mult <- arg$mult
    if (any(names(arg) == 'for.sum')) for.sum <- arg$for.sum
    if (any(names(arg) == 'defVal')) defVal <- arg$defVal
  }
  st <- new('summand')
  st@variable <- variable
  if (!is.data.frame(mult) && is.list(mult)) {
    xx <- sapply(mult, length)
    if (any(xx[1] != xx))
      stop(paste0('Wrong mult parameters '))
    if (xx[1] >= 1) {
      xx <- data.frame(stringsAsFactors = FALSE)
      xx[seq_len(length(mult[[1]])), ] <- NA
      for (i in names(mult)) xx[, i] <- mult[[i]]
      mult <- xx
    }
  }
  if (is.data.frame(mult)) {
    st@mult <- mult
  } else st@defVal <- mult
  st@for.sum <- for.sum
  if (all(names(.vrb_map) != variable)) 
    stop(paste0('Unknown variables "', variable, '"in summands "', eqt@name, '"'))
  need.set <- .vrb_map[[variable]];
  need.set <- need.set[!(need.set %in% c(names(eqt@for.each), names(st@for.sum)))];
  for (i in need.set) {
    st@for.sum[[i]] <- NULL
  }
  if (!all(names(st@mult) %in% c(names(st@for.sum), 'value')))
    stop(paste0('Wrong mult parameter, excessive set: "', paste0(names(st@mult)[!(names(st@mult) %in% names(st@for.sum))], collapse = '", "'), '"'))
  names(st@defVal) <- NULL
  names(st@variable) <- NULL
  eqt@lhs[[length(eqt@lhs) + 1]] <- st
  eqt  
}


#stm <- newStatement('testEx', for.each = list(year = 2012), rhs = data.frame(year = 2012, value = 5),
#                    summand1 = list(variable = 'vTechOut', for.sum = list(year = 2012, tech = c('ELC_COA', 'ELC_GAS')), 
#                                    mult = list(tech = 'ELC_COA', value = 2)))


# Get set values
#prec@set <- lapply(prec@parameters[sapply(prec@parameters, function(x) x@type == 'set')], function(x) getParameterData(x)[, 1])


#  .vrb_map <- energyRt:::.vrb_map
#  .vrb_mapping <- energyRt:::.vrb_mapping
# Calculate do equation need additional set, and add it
.getSetEquation <- function(prec, stm, approxim) {
  assign('prec', prec,  globalenv())
  assign('stm', stm,  globalenv())
  assign('approxim', approxim,  globalenv())
  # Add for.sum for lhs if set not declarate before
  for (i in seq_along(stm@lhs)) {
    need.set <- .vrb_map[[stm@lhs[[i]]@variable]]
    need.set <- need.set[!(need.set %in% c(names(stm@for.each), names(stm@lhs[[i]]@for.sum)))]
    if (length(need.set) != 0) {
      need.set <- c(need.set, names(stm@lhs[[i]]@for.sum))
      stm@lhs[[i]]@for.sum <- lapply(need.set, function(j) stm@lhs[[i]]@for.sum[[j]])
      names(stm@lhs[[i]]@for.sum) <- need.set
    }
  }
  # Need estimate all additional sets
  adf <- data.frame(
    name = character(),
    set = character(),
    type = character(), # for.each, lhs
    num = numeric(),    # number for lhs
    stringsAsFactors = FALSE
  )
  add.set <- list()
  # for.each
  nn <- length(stm@for.each) + sapply(stm@lhs, function(x) sum(names(x@for.sum) != 'value'))
  if (nn > 0) {
    add.set <- lapply(1:nn, function(x) NULL)
    adf[1:nn, ] <- NA
    k <- 0
    for (i in seq_along(stm@for.each)) {
      k <- k + 1
      adf[k, 'set'] <- names(stm@for.each)[i]
      adf[k, 'type'] <- 'for.each'
      if (!is.null(stm@for.each[[k]]))
        add.set[[k]] <- stm@for.each[[k]]
    }
    for (j in seq_along(stm@lhs)) {
      for (i in names(stm@lhs[[j]]@for.sum)[names(stm@lhs[[j]]@for.sum) != 'value']) {
        k <- k + 1
        adf[k, 'set'] <- i
        adf[k, 'type'] <- 'lhs'
        adf[k, 'num'] <- j
        if (!is.null(stm@lhs[[j]]@for.sum[[i]]))
          add.set[[k]] <- unique(stm@lhs[[j]]@for.sum[[i]])
      }
    }
    adf$name <- adf$set
    # 
    adf$need.new <- TRUE
    # if set contain all
    for (i in seq_along(add.set)) {
      if (is.null(add.set[[i]]) || all(add.set[[i]] %in% prec@set[[adf[i, 'set']]]))
        adf[i, 'need.new'] <- FALSE
    }
    # if set in lhs the same as for.each
    fl <- (adf$type =='lhs' & adf$name %in% adf$set[adf$type == 'for.each'])
    if (any(fl)) {
      adf[fl, 'need.new'] <- TRUE
      adf[fl, 'name'] <- paste0(adf[fl, 'name'], 'p')
    }
    add.set <- add.set[adf$need.new]
    adf <- adf[adf$need.new,, drop = FALSE]
    if (nrow(adf) > 0) {
      adf$new.name <- paste0('mCns', stm@name, '_', adf$set)
      for (i in seq_len(nrow(adf))) {
        add.set[[i]] <- prec@set[[adf[i,  'set']]]
      }
      if (anyDuplicated(adf$new.name) != 0) {
        tmp <- rep(0, nrow(adf))
        while (anyDuplicated(paste0(adf$new.name, tmp)) != 0) {
          fl <- duplicated(paste0(adf$new.name, tmp))
          tmp[fl] <- tmp[fl] + 1
        }
        tmp[tmp == 0] <- ''
        adf$new.name <- paste0(adf$new.name, tmp)
      }
      for (i in seq_len(nrow(adf))) {
        prec@parameters[[adf[i, 'new.name']]] <- addMultipleSet(createParameter(adf[i, 'new.name'], adf[i, 'set'], 'map'), add.set[[i]])
      }
    }
  }
  
  # Generate GAMS code with mult & rhs parameters
  res <- list()  
  # Declaration equation in model
  res$equationDeclaration2Model <- paste0('eqCns', stm@name)
  # Declaration equation
  if (length(stm@for.each) == 0) {
    res$equationDeclaration <- res$equationDeclaration2Model
  } else {
    res$equationDeclaration <- paste0(res$equationDeclaration2Model, '(', paste0(names(stm@for.each), collapse = ', '), ')')
  }
  # Equation before ..
  res$equation <- res$equationDeclaration
  if (any(adf$type == 'for.each') || any(names(stm@for.each) == 'year')) {
    fl <- (adf$type == 'for.each')
    hh <- NULL
    if (any(fl)) 
      hh <- paste0(adf[fl, 'new.name'], '(', adf[fl, 'name'], ')')
    res$equation <- paste0(res$equation, '$(', paste0(c(hh, 'mMidMilestone(year)'[any(names(stm@for.each) == 'year')]), collapse = ' and '), ')')
  }
  res$equation <- paste0(res$equation, '.. ')
  # Add lhs
  for (i in seq_along(stm@lhs)) {
    need.set <- .vrb_map[[stm@lhs[[i]]@variable]]
    names(need.set) <- need.set
    adf2 <- adf[adf$type == 'lhs' & adf$num == i,, drop = FALSE]
    adf3 <- adf2[adf2$name != adf2$set,, drop = FALSE]
    if (nrow(adf3) > 0) {
      need.set[adf3$set] <- adf3$name
      names(stm@lhs[[i]]@for.sum) <- need.set[names(stm@lhs[[i]]@for.sum)]
    }
    lft <- ''; rgt <- '';
    if (length(stm@lhs[[i]]@for.sum) != 0) {
      if (length(stm@lhs[[i]]@for.sum) == 1) {
        lft <- paste0('sum(', names(stm@lhs[[i]]@for.sum))
      } else {
        lft <- paste0('sum((', paste0(names(stm@lhs[[i]]@for.sum), collapse = ', '), ')')
      }
      if (nrow(adf2) > 0) {
        lft <- paste0(lft, '$', '('[nrow(adf2) != 1], paste0(paste0(adf2$new.name, '(', adf2$name, ')'), collapse = ' and '), ')'[nrow(adf2) != 1])
      }
      lft <- paste0(lft, ', ')
      rgt <- ')'
    }
    vrm <- .vrb_mapping[[stm@lhs[[i]]@variable]]
    if (length(need.set) != 0) {
      for (k in names(need.set)) {
        vrm <- gsub(paste0(' ', k, ' '), paste0(' ', need.set[k], ' '), vrm)
      }
    }
    vrm <- gsub('[ ]*$', '', gsub('[(] ', '(', gsub(' [)]', ')', gsub(' [$] ', '$', gsub(' , ', ', ', vrm)))))
    # Add multiplier
    if (nrow(stm@lhs[[i]]@mult) != 0) {
      # Complicated parameter
      # Generate approxim
      approxim2 <- approxim[unique(c(colnames(stm@lhs[[i]]@mult)[colnames(stm@lhs[[i]]@mult) %in% names(approxim)], 'solver', 'year'))]
      if (any(names(approxim2) == 'slice')) {
        approxim2$slice <- approxim2$slice@all_slice
      }
      need.set2 <- need.set
      need.set2 <- need.set2[names(need.set2) %in% colnames(stm@lhs[[i]]@mult)]
      for (j in names(need.set2)) {
        approxim2[[j]] <- unique(c(stm@lhs[[i]]@mult[, j], add.set[adf$set == j], recursive = TRUE))
      }
      xx <- createParameter(paste0('pCnsMult', i), need.set2, 'simple', defVal = stm@lhs[[i]]@defVal, interpolation = 'back.inter.forth')
      prec@parameters[[xx@name]] <- addData(xx, simpleInterpolation(stm@lhs[[i]]@mult, 'value', xx, approxim2))
      # Add mult
      vrm <- paste0(xx@name, '(', paste0(need.set2, collapse = ', '), ') * ', vrm)
    } else if (stm@lhs[[i]]@defVal != 1) {
      vrm <- paste0(stm@lhs[[i]]@defVal, ' * ', vrm)
    }
    # Finish lhs
    vrm <- paste0(lft, vrm, rgt)
    res$equation <- paste0(res$equation, ' + '[i != 1], vrm)
  }
  # Add eq
  res$equation <- paste0(res$equation, ' ', c('==' = '=e=', '>=' = '=g=', '<=' = '=l=')[as.character(stm@eq)], ' ')
  # Add rhs
  if (nrow(stm@rhs) != 0) {
    # Complicated rhs
    # Generate approxim
    approxim2 <- approxim[unique(c(colnames(stm@rhs)[colnames(stm@rhs) %in% names(approxim)], 'solver', 'year'))]
    if (any(names(approxim2) == 'slice')) {
      approxim2$slice <- approxim2$slice@all_slice
    }
    need.set2 <- names(stm@for.each)
    names(need.set2) <- need.set2
    need.set2 <- need.set2[names(need.set2) %in% colnames(stm@rhs)]
    ################ for.each
    adf2 <- adf[adf$type == 'for.each',, drop = FALSE]
    adf3 <- adf2[adf2$name != adf2$set,, drop = FALSE]
    if (nrow(adf3) > 0) {
      need.set2[adf3$set] <- adf3$name
    }
    for (j in names(need.set2)) {
      approxim2[[j]] <- unique(c(stm@rhs[, j], add.set[adf$set == j], recursive = TRUE))
    }
    xx <- createParameter(paste0('pCnsRhs', stm@name), need.set2, 'simple', defVal = stm@defVal, 
                          interpolation = 'back.inter.forth', colName = 'rhs')
    prec@parameters[[xx@name]] <- addData(xx, simpleInterpolation(stm@rhs, 'rhs', xx, approxim2))
    # Add mult
    res$equation <- paste0(res$equation, xx@name, '(', paste0(need.set2, collapse = ', '), ')')
  } else {
    res$equation <- paste0(res$equation, stm@defVal)
  }
  res$equation <- paste0(res$equation, ';')
  prec@gams.equation[[stm@name]] <- res
  prec
}

#  .getSetEquation(prec, stm, approxim) 
