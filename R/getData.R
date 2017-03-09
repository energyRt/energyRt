#' Extraxts data from scenario object
#' 
#' @obj object of class scenario or model
#' 
#' @... data search filters and parameters, which include:
#' @param parameter character vector with names of paremeters
#' @param variable character vector with names of variables
#' @param tech character vector with names of tachnology objects
#' @param dem character vector with names of demand objects
#' @param sup character vector with names of sypply objects
#' @param comm character vector with names of commodity objects
#' @param group character vector group names in technology objects
#' @param region character vector with names of regions
#' @param year character or integer vector with years
#' @param slice character vector with names of slices
#' @param stg qqq
#' @param expp character vector with names of export processes
#' @param imp character vector with names of import processes
#' @param trade character vector with names of trade objects
#' @param get.parameter logical, if TRUE then search in interpolated parameters, and return if available  
#' @param get.variable logical, if TRUE then search in variables, and return if available  
#' @param remove_zero_dim rename to 'drop.zeros' 
#' @param drop # add 'drop.zero.dim = drop' and 'remove_zero_dim = drop'
 
getData <- function(obj, ..., parameter = NULL, variable = NULL, 
                    get.parameter = NULL, get.variable = NULL, merge.table = FALSE,
                    remove_zero_dim = TRUE, drop = TRUE, astable = TRUE, use.dplyr = FALSE, 
                    stringsAsFactors = TRUE, yearsAsFactors = FALSE) {
  if (is.null(get.variable)) get.variable <- is.null(parameter) || !is.null(variable)
  if (is.null(get.parameter)) get.parameter <- is.null(variable) || !is.null(parameter)
  if (merge.table && !astable) stop('merge is possible only for data.frame')
  if (get.parameter && get.variable) {
    if (!merge.table) {
      l1 <- getDataParameter(obj, ..., parameter = parameter, merge.table = FALSE,
                             remove_zero_dim = remove_zero_dim, drop = drop, astable = astable,
                             stringsAsFactors = stringsAsFactors, yearsAsFactors = yearsAsFactors)
      l2 <- getDataResult(obj, ..., variable = variable, merge.table = FALSE,
                          remove_zero_dim = remove_zero_dim, drop = drop, astable = astable,
                             stringsAsFactors = stringsAsFactors, yearsAsFactors = yearsAsFactors)
      if (length(l1) == 0) return(l2) else
      if (length(l2) == 0) return(l1) else {    
        for(i in names(l2)) l1[[i]] <- l2[[i]]
        return(l1)
      }
    } else {
      l1 <- getDataParameter(obj, ..., parameter = parameter, merge.table = FALSE,
                             remove_zero_dim = FALSE, drop = FALSE, astable = TRUE)
      l2 <- getDataResult(obj, ..., variable = variable, merge.table = FALSE,
                          remove_zero_dim = FALSE, drop = FALSE, astable = TRUE)
      if (length(l1) == 0 && length(l2) == 0) return(NULL) else
      if (length(l1) != 0 && length(l2) != 0) {
        for(i in names(l2)) l1[[i]] <- l2[[i]]
      } else if (length(l2) != 0) l2 <- l1
      for(i in names(l1)) l1[[i]]$variable <- i
      if (use.dplyr) {
        l1 <- Reduce(function(x, y) {dplyr::full_join(x, y)}, l1)
      } else {
        l1 <- Reduce(function(x, y) {merge(x, y, all = TRUE)}, l1)
      }
      l1 <- l1[, c('variable', colnames(l1)[!(colnames(l1) %in% c('variable', 'value'))], 'value'), drop = FALSE]
      if (remove_zero_dim) {
        l1 <- l1[l1[, 'value'] != 0,, drop = FALSE]
      }
      if (drop && ncol(l1) > 2) {
        l1 <- l1[, c(TRUE, apply(l1[, -c(1, ncol(l1)), drop = FALSE], 
                    2, function(x) length(unique(x)) != 1), TRUE), drop = FALSE]
      }
      return(l1)
    }
  } else if (get.parameter) {
    return(getDataParameter(obj, ..., parameter = parameter, merge.table = merge.table,
                            remove_zero_dim = remove_zero_dim, drop = drop, astable = astable, 
                            use.dplyr = use.dplyr,
                             stringsAsFactors = stringsAsFactors, yearsAsFactors = yearsAsFactors)) 
  } else {
    return(getDataResult(obj, ..., variable = variable, merge.table = merge.table,
                         remove_zero_dim = remove_zero_dim, drop = drop, astable = astable, 
                         use.dplyr = use.dplyr,
                             stringsAsFactors = stringsAsFactors, yearsAsFactors = yearsAsFactors)) 
  }
}

getData_ <- function(obj, ..., parameter = NULL, variable = NULL, 
                     get.variable = NULL, get.parameter = NULL, merge.table = FALSE,
                     remove_zero_dim = TRUE, drop = TRUE, astable = TRUE, use.dplyr = FALSE, 
                    stringsAsFactors = TRUE, yearsAsFactors = FALSE) {
  psb_set <- c('tech', 'dem', 'sup', 'comm', 'group', 'region', 
               'year', 'slice', 'stg', 'expp', 'imp', 'trade', 'cns')
  set <- list(...)                      
  if (any(!(names(set) %in% psb_set)))
    stop(paste('Unknown set name "', paste(names(set)[!(names(set) %in% psb_set)], 
                                           collapse = '", "'), '"', sep = ''))
  for(i in names(set)) {
    set[[i]] <-  grep(set[[i]], obj@result@set[[i]], value = TRUE)
  }
  getData(obj, args = set, 
          parameter = parameter, variable = variable, get.variable = get.variable, get.parameter = get.parameter, 
          merge.table = merge.table, remove_zero_dim = remove_zero_dim, drop = drop, astable = astable, 
          use.dplyr = use.dplyr, stringsAsFactors = stringsAsFactors, yearsAsFactors = yearsAsFactors)
}


getDataResult0 <- function(obj, ..., variable = NULL, 
  remove_zero_dim = TRUE, drop = TRUE) {
  psb_set <- c('tech', 'dem', 'sup', 'comm', 'group', 'region', 
    'year', 'slice', 'stg', 'expp', 'imp', 'trade', 'cns')
  set <- list(...)
  if (any(names(set) == 'args')) set <- set$args
  if (any(!(names(set) %in% psb_set)))
    stop(paste('Unknown set name "', paste(names(set)[!(names(set) %in% psb_set)], 
      collapse = '", "'), '"', sep = ''))
  dtt <- obj@result@data
  if (!is.null(variable)) {
    if (any(!(variable %in% names(dtt)))) 
      stop(paste('getData: unknown argument: "', paste(variable[!(variable %in% names(dtt))], 
        collapse = '", "'), '"', sep = ''))
    dtt <- dtt[variable]
  }
  alias_set <- lapply(psb_set, function(x) x)
  names(alias_set) <- alias_set
  alias_set$comm = c('comm', 'acomm', 'comme')
  alias_set$region = c('region', 'regionp', 'src', 'dst')
  alias_set$year = c('year', 'yearp', 'yeare')
  alias_set <- alias_set[names(set)]
  if (length(set) != 0) {
    for(i in names(set)) {
      rmv <- rep(TRUE, length(dtt))
      names(rmv) <- names(dtt)
      for(j in names(dtt)) {
        if (any(names(dimnames(dtt[[j]])) %in% alias_set[[i]])) {
          fl <- alias_set[[i]][alias_set[[i]] %in% names(dimnames(dtt[[j]]))]
          f2 <- lapply(dimnames(dtt[[j]])[fl], function(x) x[x %in% set[[i]]])
          if (sum(sapply(f2, length) > 0) == 0) rmv[j] <- FALSE else 
          if (sum(sapply(f2, length) > 0) == 1) {
            k <- names(f2)[sapply(f2, length) > 0]
            gg <- rep('', length(dim(dtt[[j]])))
            gg[k == names(dimnames(dtt[[j]]))] <- 'dimnames(dtt[[j]])[[k]] %in% set[[i]]'
            ttt <- paste('dtt[[j]] <- dtt[[j]][', paste(gg, collapse = ','), ', drop = ', FALSE, ']', sep = '')
            eval(parse(text = ttt))
          } # Nothing to be done if more than one have searching variables
        }  else rmv[j] <- FALSE; 
      }
      dtt <- dtt[rmv]  
    }
  }
  if (drop) {
    for(j in names(dtt)) if (length(dim(dtt[[j]])) > 0) {
      if (any(dim(dtt[[j]]) != 1)) {
        kk <- names(dimnames(dtt[[j]]))[dim(dtt[[j]]) != 1]
        dtt[[j]] <- as.array(apply(dtt[[j]], seq(along = dim(dtt[[j]]))[dim(dtt[[j]]) != 1], sum))
        names(dimnames(dtt[[j]])) <- kk
      } else {
        dtt[[j]] <-c(dtt[[j]])
        names(dtt[[j]]) <- NULL
      }
    }
  }
  if (remove_zero_dim && length(dtt) != 0) {
    dtt <- dtt[sapply(dtt, function(x) any(x != 0))]
    for(j in names(dtt)) if (length(dtt[[j]]) > 1) {
      gg <- paste('apply(dtt[[j]] != 0, ', 1:length(dim(dtt[[j]])), ', any)', sep = '')
      eval(parse(text = paste('dtt[[j]] <- dtt[[j]][', paste(gg, collapse = ','), 
          ', drop = FALSE]', sep = '')))
    }
    if (drop) {
      for(j in names(dtt)) if (length(dim(dtt[[j]])) > 0) {
        if (any(dim(dtt[[j]]) != 1)) {
          kk <- names(dimnames(dtt[[j]]))[dim(dtt[[j]]) != 1]
          dtt[[j]] <- as.array(apply(dtt[[j]], seq(along = dim(dtt[[j]]))[dim(dtt[[j]]) != 1], sum))
          names(dimnames(dtt[[j]])) <- kk
        } else {
          dtt[[j]] <-c(dtt[[j]])
          names(dtt[[j]]) <- NULL
        }
      }
    }
  }
  return(dtt)
}


getDataOut <- function(obj, comm) {
  gg <- getData(obj, comm = comm, variable = c("vTechOut", 'vImport', 'vSupOut'), 
    drop = FALSE, type = 'data.frame')
  gg$var[gg$var == 'vTechOut'] <- 'tech.'
  gg$var[gg$var == 'vSupOut'] <- 'sup.'
  gg$var[gg$var == 'vImport'] <- 'import'
  if (all(colnames(gg) != 'tech')) gg[, 'tech'] <- NA
  if (all(colnames(gg) != 'sup')) gg[, 'sup'] <- NA
  gg$tech[is.na(gg$tech)] <- ''
  gg[['src']] <- paste(gg$var, gg$tech, gg$sup, sep = '')
  tapply(gg$value, gg[, c('year', 'src')], sum)
}

getVariableParameterName <- function(obj) {
  fl <- names(obj@precompiled@maptable)[sapply(obj@precompiled@maptable, function(x) 
    x@type %in% c('single', 'double'))]
  c(fl, names(obj@result@data))
}

getDataParameter <- function(obj, ..., parameter = NULL, 
  remove_zero_dim = TRUE, drop = TRUE, astable = TRUE, merge.table = FALSE, use.dplyr = FALSE,
                             stringsAsFactors = TRUE, yearsAsFactors = FALSE) {
  psb_set <- c('tech', 'dem', 'sup', 'comm', 'group', 'region', 
    'year', 'slice', 'stg', 'expp', 'imp', 'trade', 'cns')
  set <- list(...)                      
  if (any(names(set) == 'args')) set <- set$args
  if (any(!(names(set) %in% psb_set)))
    stop(paste('Unknown set name "', paste(names(set)[!(names(set) %in% psb_set)], 
      collapse = '", "'), '"', sep = ''))
  fl <- names(obj@precompiled@maptable)[sapply(obj@precompiled@maptable, function(x) 
    x@type %in% c('single', 'double'))]
  dtt <- lapply(obj@precompiled@maptable[fl], function(y) getDataMapTable(y))
  if (!is.null(parameter)) {
    if (any(!(parameter %in% names(dtt)))) 
      stop(paste('getDataParameter0: unknown argument: "', paste(parameter[!(parameter %in% names(dtt))], 
        collapse = '", "'), '"', sep = ''))
    dtt <- dtt[parameter]
  }
  alias_set <- lapply(psb_set, function(x) x)
  names(alias_set) <- alias_set
  alias_set$comm = c('comm', 'acomm', 'comme')
  alias_set$region = c('region', 'regionp', 'src', 'dst')
  alias_set$year = c('year', 'yearp', 'yeare')
  alias_set <- alias_set[names(set)]
  if (length(set) != 0) {
    for(i in names(set)) {
      rmv <- rep(TRUE, length(dtt))
      names(rmv) <- names(dtt)
      for(j in names(dtt)) {
        if (any(colnames(dtt[[j]])[-ncol(dtt[[j]])] %in% alias_set[[i]])) {
          fl <- alias_set[[i]][alias_set[[i]] %in% colnames(dtt[[j]])[-ncol(dtt[[j]])]]
          f2 <- sapply(fl, function(x) any(dtt[[j]][, fl] %in% set[[i]]))
          if (sum(f2) == 0) rmv[j] <- FALSE else 
          if (sum(f2) == 1) {
            k <- fl[f2]
            dtt[[j]] <- dtt[[j]][dtt[[j]][, k] %in% set[[i]],, drop = FALSE]
          } # Nothing to be done if more than one have searching variables
        }  else rmv[j] <- FALSE; 
      }
      dtt <- dtt[rmv]  
    }
  }
  for(j in names(dtt)) {
    colnames(dtt[[j]])[ncol(dtt[[j]])] <- "value"
  } 
  if (!merge.table) {
    if (drop) {
      for(j in names(dtt)) if (ncol(dtt[[j]]) > 1) {
        dtt[[j]] <- dtt[[j]][, c(apply(dtt[[j]][, -ncol(dtt[[j]]), drop = FALSE], 2, 
          function(x) any(x != x[1])), TRUE), drop = FALSE]
      }
    }
    if (remove_zero_dim && length(dtt) != 0) {
      dtt <- dtt[sapply(dtt, function(x) any(x[, ncol(x)] != 0))]
      for(j in names(dtt)) {
        dtt[[j]] <- dtt[[j]][dtt[[j]][, ncol(dtt[[j]])] != 0,, drop = FALSE]
      }
      if (drop) {
        for(j in names(dtt)) if (ncol(dtt[[j]]) > 1) {
          dtt[[j]] <- dtt[[j]][, c(apply(dtt[[j]][, -ncol(dtt[[j]]), drop = FALSE], 2, 
          function(x) any(x != x[1])), TRUE), drop = FALSE]
        }
      }
    }
  }
  dtt <- dtt[sapply(dtt, nrow) > 0]
  if (!astable) {
    gg <- names(dtt)
    dtt <- lapply(dtt, function(x) if (ncol(x) == 1) x[1, 1] else tapply(x[, ncol(x)], x[, -ncol(x), drop = FALSE], sum))
    names(dtt) <- gg
  } else {
    if (merge.table) {
        if (use.dplyr) {
          dtt <- Reduce(function(x, y) {dplyr::full_join(x, y)}, dtt)
        } else {
          dtt <- Reduce(function(x, y) {merge(x, y, all = TRUE)}, dtt)
        }
        dtt <- dtt[, c('variable', colnames(dtt)[!(colnames(dtt) %in% c('variable', 'value'))], 'value')]
        #
        if (drop && ncol(dtt) > 1) {
            dtt <- dtt[, c(TRUE, apply(dtt[, -c(1, ncol(dtt)), drop = FALSE], 2, 
                                           function(x) length(unique(x)) != 1), TRUE), drop = FALSE]
        }
        if (remove_zero_dim && length(dtt) != 0) {
          dtt <- dtt[sapply(dtt, function(x) any(x[, ncol(x)] != 0))]
          dtt <- dtt[dtt[, ncol(dtt)] != 0,, drop = FALSE]
          if (drop && ncol(dtt) > 1) {
            dtt <- dtt[, c(TRUE, apply(dtt[, -c(1, ncol(dtt)), drop = FALSE], 2, 
                                       function(x) length(unique(x)) != 1), TRUE), drop = FALSE]
          }
        }
        #
      }  
  }
  set <- obj@result@set
  set$year <- obj@model@sysInfo@year
  set$yearp <- set$year
  set$variable <- getVariableParameterName(obj)
  if (merge.table) {
    if (!is.null(dtt) && ncol(dtt) > 1) {
      cc <- NULL
      if (stringsAsFactors) 
        cc <- colnames(dtt)[!(colnames(dtt) %in% c('year', 'yearp', 'value'))]
      if (yearsAsFactors) 
        cc <- c(cc, colnames(dtt)[colnames(dtt) %in% c('year', 'yearp')])
      for(i in cc) {
        dtt[, i] <- factor(dtt[, i], levels = set[[i]])
      } 
    }
  } else if (astable) {
    for(j in names(dtt)) if (ncol(dtt[[j]]) > 1) {
      cc <- NULL
      if (stringsAsFactors) 
        cc <- colnames(dtt[[j]])[!(colnames(dtt[[j]]) %in% c('year', 'yearp', 'value'))]
      if (yearsAsFactors) 
        cc <- c(cc, colnames(dtt[[j]])[colnames(dtt[[j]]) %in% c('year', 'yearp')])
      for(i in cc) {
        dtt[[j]][, i] <- factor(dtt[[j]][, i], levels = set[[i]])
      } 
    }
  }
  if (length(dtt) == 0) return(NULL) else return(dtt)
}

getDataResult <- function(obj, ..., astable = TRUE, use.dplyr = FALSE, merge.table = TRUE,
  remove_zero_dim = TRUE, drop = TRUE, stringsAsFactors = TRUE, yearsAsFactors = FALSE) {
  if (astable) {
    lmx <- getDataResult0(obj, ..., remove_zero_dim = FALSE, drop = FALSE)
    set <- obj@result@set
    set$year <- obj@model@sysInfo@year
    set$yearp <- set$year
    set$variable <- getVariableParameterName(obj)
    if (merge.table) {
      ltb <- lapply(names(lmx), function(x) {
        if (is.null(dim(lmx[[x]]))) return(data.frame(variable = as.factor(x), value = lmx[[x]]))
        y <- as.data.frame.table(lmx[[x]], responseName = "value0")
        y$variable <- as.factor(x)
        y$value <- y$value0
        y$value0 <- NULL
        return(y)
      })
      names(ltb) <- names(lmx)
      if (use.dplyr) {
        dft <- Reduce(function(x, y) {dplyr::full_join(x, y)}, ltb)
      } else {
        dft <- Reduce(function(x, y) {merge(x, y, all = TRUE)}, ltb)
      }
      dft <- dft[, c(colnames(dft)[colnames(dft) != 'value'], 'value'), drop = FALSE]       
      
      if (remove_zero_dim) {
        dft <- dft[dft$value != 0,, drop = FALSE]
      }
      dft <- dft[,c('variable', colnames(dft)[!(colnames(dft) %in% c('value', 'variable'))], 'value'), 
        drop = FALSE]
      if (drop) {
        if (!is.null(dft) && ncol(dft) > 2) dft <- dft[, c(TRUE, sapply(dft[, -c(1, ncol(dft)), drop = FALSE], 
          function(x) length(unique(x)) != 1), TRUE), drop = FALSE]
      }
      if (!is.null(dft) && ncol(dft) > 1) {
        for(i in 2:ncol(dft) - 1) dft[, i] <- as.character(dft[, i])
        for(i in colnames(dft)[colnames(dft) %in% c('year', 'yearp')]) 
          dft[, i] <- as.numeric(dft[, i])
        cc <- NULL
        if (stringsAsFactors) 
          cc <- colnames(dft)[!(colnames(dft) %in% c('year', 'yearp', 'value'))]
        if (yearsAsFactors) 
          cc <- c(cc, colnames(dft)[colnames(dft) %in% c('year', 'yearp')])
        for(i in cc) {
          dft[, i] <- factor(dft[, i], levels = set[[i]])
        } 
      }
      if (length(dft) == 0) return(NULL) else return(dft)
    } else {
      ltb <- lapply(names(lmx), function(x) {
        if (is.null(dim(lmx[[x]]))) return(data.frame(variable = as.factor(x), value = lmx[[x]]))
        as.data.frame.table(lmx[[x]], responseName = "value")
      })
      names(ltb) <- names(lmx)
      for(i in names(lmx)) {
        if (remove_zero_dim) {
          ltb[[i]] <- ltb[[i]][ltb[[i]]$value != 0,, drop = FALSE]
        }
        if (drop) {
          if (ncol(ltb[[i]]) > 1) ltb[[i]] <- ltb[[i]][, c(sapply(ltb[[i]][, -ncol(ltb[[i]]), drop = FALSE], 
            function(x) length(unique(x)) != 1), TRUE), drop = FALSE]
        }
      }
      ltb <- ltb[sapply(ltb, nrow) !=0]
      for(j in names(ltb)) if (ncol(ltb[[j]]) > 1) {
          for(i in 2:ncol(ltb[[j]]) - 1) ltb[[j]][, i] <- as.character(ltb[[j]][, i])
          for(i in colnames(ltb[[j]])[colnames(ltb[[j]]) %in% c('year', 'yearp')]) 
            ltb[[j]][, i] <- as.numeric(ltb[[j]][, i])
          cc <- NULL
          if (stringsAsFactors) 
            cc <- colnames(ltb[[j]])[!(colnames(ltb[[j]]) %in% c('year', 'yearp', 'value'))]
          if (yearsAsFactors) 
            cc <- c(cc, colnames(ltb[[j]])[colnames(ltb[[j]]) %in% c('year', 'yearp')])
          for(i in cc) {
            ltb[[j]][, i] <- factor(ltb[[j]][, i], levels = set[[i]])
          } 
      }
      if (length(ltb) == 0) return(NULL) else return(ltb)
    }
  } else {
    lmx <- getDataResult0(obj, ..., remove_zero_dim = remove_zero_dim, drop = drop)
    if (length(lmx) == 0) return(NULL) else return(lmx)
  }
} 

