#---------------------------------------------------------------------------------------------------------
# equation
#---------------------------------------------------------------------------------------------------------
#' Class 'constraint'
#'
#' @slot name character. 
#' @slot description character. 
#' @slot eq factor. 
#' @slot for.each list. 
#' @slot rhs data.frame. 
#' @slot defVal numeric. 
#' @slot lhs list. 
#' @slot misc list. 
#'
setClass('constraint', 
         representation(
           name          = "character",
           description   = "character",       # description
           eq            = "factor",
           for.each      = "data.frame",
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
           for.each      = data.frame(),
           rhs           = data.frame(),
           defVal        = 0,
           lhs           = list(),
           #! Misc
           misc = list(
           )),
         S3methods = TRUE
);
setMethod("initialize", "constraint", function(.Object, ...) {
  .Object
})


#---------------------------------------------------------------------------------------------------------
# term for equation
#---------------------------------------------------------------------------------------------------------
#' Title
#'
#' @slot description character. 
#' @slot variable character. 
#' @slot for.sum list. 
#' @slot mult data.frame. 
#' @slot defVal numeric. 
#' @slot misc list. 
#' 
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


#' Create (equality or inequality) constraint object
#'
#' @param name Name of the constrain object (will be used in GAMS or GLPK as an element in sets)
#' @param eq Type of the relation ('==' default, '<=', '>=')
#' @param for.each list with sets for which constraint will be created.
#' @param ... Left-hand side (LHS) terms of the statement - list objects with
#' @param rhs list or data frame with named sets ()
#' @param defVal the default value for the rhs.
#' @param arg tbc
#'
#' @return Object of class `constraint`.
#'
#'    
newConstraint <- function(name, ..., eq = '==', rhs = data.frame(), for.each = NULL, defVal = 0, arg = NULL) {
  obj <- new('constraint')
  #stopifnot(length(eq) == 1 && eq %in% levels(obj@eq))
  if (length(eq) != 1 || !(eq %in% levels(obj@eq)))   {
    stop('Wrong condition type')
  }
  obj@eq[] <- eq
  if (is.numeric(rhs)) {
    if (length(rhs) != 1) 
      stop(paste0('Wrong rhs parameters '))
    defVal <- rhs
    rhs <- data.frame()
  }
  if (!is.data.frame(rhs) && is.list(rhs)) {
    tmp = sapply(rhs, length)
    if (any(tmp[1] != tmp) || is.null(names(rhs)))
      stop(paste0('Wrong rhs parameters '))
    rhs <- as.data.frame(rhs, stringsAsFactors = FALSE)
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
  if (!is.null(for.each)) {
    if (!is.data.frame(for.each) && is.list(for.each)) {
      tmp <- data.frame(stringsAsFactors = FALSE)
      fl_null <- sapply(for.each, is.null)
      for (i in names(for.each)[fl_null]) {
        for.each[[i]] <- NA
      }     
      for (i in names(for.each)) {
        t2 <- data.frame(for.each[[i]], stringsAsFactors = FALSE)
        colnames(t2) <- i
        if (ncol(tmp) == 0) {
          tmp <- t2
        } else {
          tmp <- merge(tmp, t2)
        }
      }
      obj@for.each  <- tmp
    } else if (is.data.frame(for.each)) {
      obj@for.each  <- for.each
    } else stop("Unknown argument 'for.each'")
  }
  for (i in seq_along(arg)) {
    obj <- addSummand(obj, arg = arg[[i]])
  }
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
  # eqt, variable, mult, for.sum, arg
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
    st@for.sum[i] <- list(NA)
  }
  if (length(st@for.sum) != 0)
    st@for.sum[sapply(st@for.sum, is.null)] <- NA
  if (!all(names(st@mult) %in% c(names(eqt@for.each), names(st@for.sum), 'value')))
    stop(paste0('Wrong mult parameter, excessive set: "', paste0(names(st@mult)[!(names(st@mult) %in% names(st@for.sum))], collapse = '", "'), '"'))
  names(st@defVal) <- NULL
  names(st@variable) <- NULL
  eqt@lhs[[length(eqt@lhs) + 1]] <- st
  eqt  
}

# .vrb_map <- energyRt:::.vrb_map
# .vrb_mapping <- energyRt:::.vrb_mapping
# prec <- add0_message$add0_arg$obj
# stm <- add0_message$add0_arg$app
# approxim <- add0_message$add0_arg$approxim

# Calculate do equation need additional set, and add it
.getSetEquation <- function(prec, stm, approxim) {
  stop.constr <- function(x) 
    stop(paste0('Constraint "', stm@name, '" error: ', x))
  get.all.child <- function(x)  {
    unique(c(x, c(approxim$slice@all_parent_child[approxim$slice@all_parent_child$parent %in% x, 'child'])))
  }
  # all.set contain all set for for.each & lhs
  # Estimate is need sum for for.each
  # set.map need special mapping or consist all set
  all.set <- data.frame(
    alias = character(), # name in equation
    set = character(),  # original set 
    for.each = logical(), # for.each, lhs
    lhs.num = numeric(),    # number for lhs
    lead.year = logical(),   # use only for year & lhs (next year)
    lag.year = logical(),    # use only for year & lhs (old year)
    def.lhs  = logical(),    # not in for.each
    new.map  = numeric(),    # need new sub set
    stringsAsFactors = FALSE
  )
  set.map <- list()
  set.map.name <- NULL # Temp vector with name for list set.map
  # all.set & set.map
  # for.each
  
  old_for_each <- lapply(stm@for.each, function(x) {
    if (any(is.na(x))) return(NULL) 
    return (unique(x))
  })
  names(old_for_each) <- colnames(stm@for.each)
  nn <- seq_len(length(old_for_each) + sum(sapply(stm@lhs, function(x) length(.vrb_map[[x@variable]]))))
  all.set[seq_along(nn), ] <- NA
  for (i in (1:ncol(all.set))[sapply(all.set, class) == 'logical']) 
    all.set[, i] <- FALSE
  nn <- 0
  if (length(old_for_each) > 0) {
    nn <- seq_along(old_for_each)
    all.set[nn, 'set'] <- names(old_for_each)
    all.set[nn, 'alias'] <- names(old_for_each)
    all.set[nn, 'for.each'] <- TRUE
    for.each.set <- names(old_for_each)
    # Fill add.map for for.each
    for (j in for.each.set) {
      if (!is.null(old_for_each[[j]]) && !all(prec@set[[j]] %in% old_for_each[[j]])) {
        if (any(old_for_each[[j]] %in% prec@set[[j]])) {
          # warning(paste0('Set "'))
          old_for_each[[j]] <- old_for_each[[j]][old_for_each[[j]] %in% prec@set[[j]]]
        }
        set.map.name <- c(set.map.name, j)
        set.map[[length(set.map.name)]] <- old_for_each[[j]]
        all.set[nn[names(old_for_each) == j], 'new.map'] <- length(set.map.name)
      }
    }
  } else for.each.set <- NULL
  # lhs
  for (i in seq_along(stm@lhs)) {
    need.set <- .vrb_map[[stm@lhs[[i]]@variable]]
    nn <- (nn[length(nn)] + seq_along(need.set))
    all.set[nn, 'set'] <- need.set
    all.set[nn, 'alias'] <- need.set
    all.set[nn, 'lhs.num'] <- i
    if (any(names(stm@lhs[[i]]@for.sum) == 'lag.year')) {
      if (all(need.set != 'year'))
        stop.constr('For lag.year have to define use variable with year')
      all.set[nn[need.set == 'year'], c('lag.year', 'def.lhs')] <- TRUE
    }
    if (any(names(stm@lhs[[i]]@for.sum) == 'lead.year')) {
      if (all(need.set != 'year'))
        stop.constr('For lead.year have to define use variable with year')
      all.set[nn[need.set == 'year'], c('lead.year', 'def.lhs')] <- TRUE
    }
    all.set[nn[need.set %in% names(stm@lhs[[i]]@for.sum)], 'def.lhs'] <- TRUE
    all.set[nn[!(need.set %in% for.each.set)], 'def.lhs'] <- TRUE
    # Add to set map
    st <- names(stm@lhs[[i]]@for.sum)[names(stm@lhs[[i]]@for.sum) %in% need.set & 
                                        !sapply(is.na(stm@lhs[[i]]@for.sum), all)]
   # Fill add.map for for.lhs
    for (j in st) {
      if (!is.null(stm@lhs[[i]]@for.sum[[j]]) && 
          !all(prec@set[[j]] %in% stm@lhs[[i]]@for.sum[[j]]) && (j != 'slice' || 
                !all(prec@set[[j]] %in% get.all.child(stm@lhs[[i]]@for.sum[[j]])))) {
        # check if the same set in lhs exist
        fl <- FALSE
        if (all(!c(all.set[nn[need.set == j], c('lead.year', 'lag.year')], recursive = TRUE))) {
          fl <- nn[(!all.set$for.each[nn] & all.set$set[nn] == j & !is.na(all.set$new.map[nn]))]
        }
        add.new <- TRUE
        if (any(fl)) {
          for (k in all.set[fl, 'new.map']) {
            if (length(stm@lhs[[i]]@for.sum[[j]]) == length(set.map[[k]]) && 
                all(stm@lhs[[i]]@for.sum[[j]] %in% set.map[[k]])  && all(set.map[[k]] %in% stm@lhs[[i]]@for.sum[[j]])) {
              all.set[nn[need.set == j], 'new.map'] <- k
              add.new <- FALSE
            }
          }
        }
        if (add.new) {
          set.map.name <- c(set.map.name, j)
          set.map[[length(set.map.name)]] <- stm@lhs[[i]]@for.sum[[j]]
          all.set[nn[need.set == j], 'new.map'] <- length(set.map.name)
        }
      }
    }
  }
  # Add alias
  fl <- (!all.set$for.each & all.set$def.lhs & all.set$set %in% for.each.set)
  if (any(fl)) 
    all.set[fl, 'alias'] <- paste0(all.set[fl, 'set'], 'p')
  # Need add code to reduce additional mapping
  # Maaping
  if (length(set.map) > 0) {
    mpp <- all.set[!is.na(all.set$new.map), c('new.map', 'alias')]
    mpp <- mpp[!duplicated(mpp$new.map), ]
    mpp <- mpp[sort(mpp$new.map, index.return = TRUE)$ix,, drop = FALSE]
    new.map.name <- paste0('mCns', stm@name, '_', mpp$new.map)
    new.map.name.full <- paste0(new.map.name, '(', mpp$alias, ')')
    for (i in seq_along(set.map)) 
      prec@parameters[[new.map.name[i]]] <- addMultipleSet(newParameter(new.map.name[i], set.map.name[i], 'map'), c(set.map[[i]]))
    
    # copy new.map for lhs set that define in for each
    fl <- seq_len(nrow(all.set))[all.set$for.each & !is.na(all.set$new.map)]
    for (i in fl) {
      all.set[!all.set$for.each & !all.set$def.lhs & all.set$set == all.set$set[i], 'new.map'] <- i
    }
  }
  if (nrow(all.set) > 0) {
    st <- unique(all.set$set)
    st <- st[!(st %in% names(approxim))]
    for (ss in st) approxim[[ss]] <- prec@set[[ss]]
  }

  # Generate GAMS code with mult & rhs parameters
  res <- list()  
  # Declaration equation in model
  res$equationDeclaration2Model <- paste0('eqCns', stm@name)
  # Declaration equation
  if (length(old_for_each) == 0) {
    res$equationDeclaration <- res$equationDeclaration2Model
  } else {
    res$equationDeclaration <- paste0(res$equationDeclaration2Model, '(', paste0(names(old_for_each), collapse = ', '), ')')
  }
 # Equation before ..
  res$equation <- res$equationDeclaration
  if (any(is.na(stm@for.each))) {
    tmp_fe <- stm@for.each
    fl_na <- colnames(stm@for.each)[apply(is.na(stm@for.each), 2, any)]
    for (i in fl_na) {
      tmg <- prec@parameters[[i]]@data
      if (i == 'year') {
        tmg <- prec@parameters[['mMidMilestone']]@data
        if (any(all.set$lag.year)) { 
          tmg <- tmg[!(tmg$year %in% prec@parameters[['mMilestoneFirst']]@data$year),, drop = FALSE]
        }
        if (any(all.set$lead.year)) { 
          tmg <- tmg[tmg$year %in% prec@parameters[['mMilestoneHasNext']]@data$year,, drop = FALSE]
        }
      }
      tmp_fe <- rbind(merge(tmp_fe[, colnames(tmp_fe) != i, drop = FALSE], tmg),
        tmp_fe[!is.na(tmp_fe[[i]]),, drop = FALSE])
      tmp_fe <- tmp_fe[!duplicated(tmp_fe),, drop = FALSE]
    }
    stm@for.each <- tmp_fe
  }
  if (!is.null(stm@for.each$year)) {
    stm@for.each <- stm@for.each[stm@for.each$year %in% prec@parameters[['mMidMilestone']]@data$year,, drop = FALSE]
    if (any(all.set$lag.year)) { 
      stm@for.each <- stm@for.each[!(stm@for.each$year %in% prec@parameters[['mMilestoneFirst']]@data$year),, drop = FALSE]
    }
    if (any(all.set$lead.year)) { 
      stm@for.each <- stm@for.each[stm@for.each$year %in% prec@parameters[['mMilestoneHasNext']]@data$year,, drop = FALSE]
    }
  }
  if (nrow(stm@for.each) > 0) {
    nmn <- paste0('mCnsForEach', stm@name)
    prec@parameters[[nmn]] <- .add_data(newParameter(nmn, colnames(stm@for.each), 'map'),
      stm@for.each)
    res$equation <- paste0(res$equation, '$', nmn, '(', paste0(colnames(stm@for.each), collapse = ', '), ')')
  }
  res$equation <- paste0(res$equation, '.. ')
  # Add lhs to equation
  lhs.set <- all.set[!all.set$for.each,, drop = FALSE]
  for (i in seq_along(stm@lhs)) {
    vrb <- stm@lhs[[i]]@variable
    lhs.set2 <- lhs.set[lhs.set$lhs.num == i, ]
    vrb.lhs <- .vrb_mapping[[vrb]]
    # Add multiple to vrb
    # Add to year multiplier if lag.year | lead.year
    if ((any(lhs.set2$lead.year) || any(lhs.set2$lag.year)) && (nrow(stm@lhs[[i]]@mult) == 0 ||  all(colnames(stm@lhs[[i]]@mult) != 'year'))) {
      if (nrow(stm@lhs[[i]]@mult) == 0) {
        stm@lhs[[i]]@mult <- data.frame(year = NA, value = stm@lhs[[i]]@defVal, stringsAsFactors = FALSE)
      } else {
        stm@lhs[[i]]@mult$year <- NA
      }
    }
    # Add multiplier
    if (nrow(stm@lhs[[i]]@mult) != 0) {
      # Complicated parameter
      # Generate approxim
      approxim2 <- approxim[unique(c(colnames(stm@lhs[[i]]@mult)[colnames(stm@lhs[[i]]@mult) %in% names(approxim)], 'solver', 'year'))]
      if (any(names(approxim2) == 'slice')) {
        approxim2$slice <- approxim2$slice@all_slice
      }
      need.set <- lhs.set2[lhs.set2$set %in% colnames(stm@lhs[[i]]@mult), 'set']
      need.set2 <- lhs.set2[!is.na(lhs.set2$new.map) & lhs.set2$set %in% colnames(stm@lhs[[i]]@mult), ]
      
      for (j in seq_len(nrow(need.set2))) {
        approxim2[[need.set2[j, 'set']]] <- set.map[[need.set2[j, 'new.map']]]
      }
      approxim2$fullsets <- approxim$fullsets
      xx <- newParameter(paste0('pCnsMult', stm@name, '_', i), need.set, 'simple', defVal = stm@lhs[[i]]@defVal, 
                            interpolation = 'back.inter.forth')
      prec@parameters[[xx@name]] <- .add_data(xx, simpleInterpolation(stm@lhs[[i]]@mult, 'value', xx, approxim2))
      if (any(lhs.set2$lead.year) || any(lhs.set2$lag.year)) {
        yy <- .add_dropped_zeros(prec, xx@name)
        nn <- approxim$mileStoneForGrowth[as.character(yy$year)]
        if (any(lhs.set2$lag.year)) nn <- (-nn)
        yy$value <- (sign(yy$value) * abs(yy$value) ^ nn)
        prec@parameters[[xx@name]] <- .add_data(xx, yy)
      }
      # Add mult
      vrb.lhs <- paste0(xx@name, '(', paste0(need.set, collapse = ', '), ') * ', vrb.lhs)
    } else if (stm@lhs[[i]]@defVal != 1) {
      vrb.lhs <- paste0(stm@lhs[[i]]@defVal, ' * ', vrb.lhs)
    }
    # Replace setsname
    for (j in seq_len(nrow(lhs.set2))[lhs.set2$alias != lhs.set2$set]) {
      vrb.lhs <- gsub(paste0(' ', lhs.set2$set[j], ' '), lhs.set2$alias[j], vrb.lhs)
    }
    vrb.lhs <- gsub('[ ]*[$][ ]*', '$', gsub('[ ]*[)]', ')', gsub('[ ]*[(][ ]*', '(', gsub('[ ]*[,][ ]*', ', ', vrb.lhs))))
    # Generate data to equation
    if (i != 1) res$equation <- paste0(res$equation, '+')
    if (all(!lhs.set2$def.lhs)) {
      res$equation <- paste0(res$equation, vrb.lhs)
    } else {
      lhs.set3 <- lhs.set2[lhs.set2$def.lhs,, drop = FALSE]
      cnd <- NULL
      if (any(!is.na(lhs.set3$new.map))) { 
        cnd <- c(cnd, new.map.name.full[lhs.set3$new.map[!is.na(lhs.set3$new.map)]])
      }
      if (any(lhs.set3$lag.year == 'year')) { 
        cnd <- c(cnd, 'mMilestoneNext(yearp, year)')
      } else if (any(lhs.set3$lead.year)) { 
        cnd <- c(cnd, 'mMilestoneNext(year, yearp)')
      } else if (any(lhs.set3$set == 'year')) { 
        cnd <- c(cnd, 'mMidMilestone(year)')
      }
      if (any(grep('[$]', vrb.lhs))) {
        tmp <- gsub('.*[$]', '', vrb.lhs)
        if (substr(tmp, 1, 1) == '(') 
          tmp <- substr(tmp, 2, nchar(tmp) - 1)
        cnd <- c(cnd, tmp)
        vrb.lhs <- gsub('[$].*', '', vrb.lhs)
      }
      # Finish for sum
      if (sum(lhs.set2$def.lhs) == 1) {
        res$equation <- paste0(res$equation, ' sum(', lhs.set3$alias);
      } else {
        res$equation <- paste0(res$equation, ' sum((', paste0(lhs.set3$alias, collapse = ', '), ')');
      }
      if (length(cnd) > 1 || any(grep('[ )]and[ (]', cnd))) {
        res$equation <- paste0(res$equation, '$(', paste0(cnd, collapse = ' and '), '), ', vrb.lhs, ')')
      } else if (length(cnd) == 1) {
        res$equation <- paste0(res$equation, '$', cnd, ', ', vrb.lhs, ')')
      } else {
        stop('error!')
      }
    }
  }
 # Add eq
  res$equation <- paste0(res$equation, ' ', c('==' = '=e=', '>=' = '=g=', '<=' = '=l=')[as.character(stm@eq)], ' ')
  # Add rhs
  if (nrow(stm@rhs) != 0 && (any(stm@rhs$rhs != 0) || (stm@defVal != 0 && nrow(stm@for.each) > nrow(stm@rhs)))) {
    # Complicated rhs
    # Generate approxim
    approxim2 <- approxim[unique(c(colnames(stm@rhs)[colnames(stm@rhs) %in% names(approxim)], 'solver', 'year'))]
    if (any(names(approxim2) == 'slice')) {
      approxim2$slice <- approxim2$slice@all_slice
    }
    fl <- (all.set$for.each & !is.na(all.set$new.map) & all.set$set %in% colnames(stm@rhs))
    need.set <- all.set[fl,, drop = FALSE]
    for (j in seq_len(nrow(need.set))) {
      approxim2[[need.set[j, 'set']]] <- set.map[[need.set[j, 'new.map']]]
    }
    approxim2$fullsets <- approxim$fullsets
    need.set0 <- for.each.set[for.each.set %in% colnames(stm@rhs)]
    xx <- newParameter(paste0('pCnsRhs', stm@name), need.set0, 'simple', defVal = stm@defVal, 
                          interpolation = 'back.inter.forth', colName = 'rhs')
    yy <- simpleInterpolation(stm@rhs, 'rhs', xx, approxim2)
    n1 <- colnames(yy)[colnames(yy) != 'value']
    yy <- yy[(apply(yy[, n1, drop = FALSE], 1, paste0, collapse = '##') %in% 
      apply(stm@for.each[, n1, drop = FALSE], 1, paste0, collapse = '##')),, drop = FALSE]
    prec@parameters[[xx@name]] <- .add_data(xx, yy)
    # Add mult
    res$equation <- paste0(res$equation, xx@name, '(', paste0(need.set0, collapse = ', '), ')')
  } else {
    res$equation <- paste0(res$equation, stm@defVal)
  }
  res$equation <- gsub('[+][[:blank:]]*[-]', '-', res$equation)
  res$equation <- paste0(res$equation, ';')
  prec@gams.equation[[stm@name]] <- res
  prec
}

#  .getSetEquation(prec, stm, approxim)@gams.equation


