#' Extraxts data from scenario object
#' 
#' @obj object of class scenario or model
#' 
#' filters:
#' @param tech character vector with tachnology names
#' @param dem 
#' @param sup
#' @param comm
#' @param group
#' @param region
#' @param year
#' @param slice
#' @param stg
#' @param expp
#' @param imp
#' @param trade
#' @param variable
#' @param remove_zero_dim
#' @param drop


#


getDataResult0 <- function(obj, ..., variable = NULL, 
  remove_zero_dim = TRUE, drop = TRUE) {
  psb_set <- c('tech', 'dem', 'sup', 'comm', 'group', 'region', 
    'year', 'slice', 'stg', 'expp', 'imp', 'trade')
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

getDataParameter <- function(obj, ..., parameter = NULL, 
  remove_zero_dim = TRUE, drop = TRUE, astable = TRUE, merge.table = FALSE, use.dplyr = FALSE) {
  psb_set <- c('tech', 'dem', 'sup', 'comm', 'group', 'region', 
    'year', 'slice', 'stg', 'expp', 'imp', 'trade')
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
  if (drop) {
    for(j in names(dtt)) if (ncol(dtt[[j]]) > 1) {
      dtt[[j]] <- dtt[[j]][, c(apply(dtt[[j]][, -ncol(dtt[[j]]), drop = FALSE], 
        2, function(x) length(unique(x)) > 1), TRUE), drop = FALSE]
    }
  }
  if (remove_zero_dim && length(dtt) != 0) {
    dtt <- dtt[sapply(dtt, function(x) any(x[, ncol(x)] != 0))]
    for(j in names(dtt)) {
      dtt[[j]] <- dtt[[j]][dtt[[j]][, ncol(dtt[[j]])] != 0,, drop = FALSE]
    }
    if (drop) {
      for(j in names(dtt)) if (ncol(dtt[[j]]) > 1) {
        dtt[[j]] <- dtt[[j]][, c(apply(dtt[[j]][, -ncol(dtt[[j]]), drop = FALSE], 
          2, function(x) length(unique(x)) > 1), TRUE), drop = FALSE]
      }
    }
  }
  dtt <- dtt[sapply(dtt, nrow) > 0]
  if (!astable) {
    gg <- names(dtt)
    dtt <- lapply(dtt, function(x) tapply(x[, ncol(x)], x[, -ncol(x), drop = FALSE], sum))
    names(dtt) <- gg
    if (merge.table) {
      if (use.dplyr) {
        dtt <- Reduce(function(x, y) {dplyr::full_join(x, y)}, dtt)
      } else {
        dtt <- Reduce(function(x, y) {merge(x, y, all = TRUE)}, dtt)
      }
    }  
  } else {
    for(j in names(dtt)) {
      colnames(dtt[[j]])[ncol(dtt[[j]])] <- "value"
    }
  }
  return(dtt)
}

getDataResult <- function(obj, ..., astable = TRUE, use.dplyr = FALSE, merge.table = TRUE,
  remove_zero_dim = TRUE, drop = TRUE) {
  lmx <- getDataResult0(obj, ...)
  if (astable) {
    if (merge.table) {
      ltb <- lapply(names(lmx), function(x) {
        if (is.null(dim(lmx[[x]]))) return(NULL)
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
      if (drop) {
        dft <- dft[, c(sapply(dft[, -ncol(dft), drop = FALSE], 
          function(x) any(x[1] != x)), TRUE), drop = FALSE]
      }
      return(dft)
    } else {
      ltb <- lapply(names(lmx), function(x) {
        if (is.null(dim(lmx[[x]]))) return(NULL)
        as.data.frame.table(lmx[[x]], responseName = "value")
      })
      names(ltb) <- names(lmx)
      for(i in names(lmx)) {
        if (remove_zero_dim) {
          ltb[[i]] <- ltb[[i]][ltb[[i]]$value != 0,, drop = FALSE]
        }
        if (drop) {
          ltb[[i]] <- ltb[[i]][, c(sapply(ltb[[i]][, -ncol(ltb[[i]]), drop = FALSE], 
            function(x) any(x[1] != x)), TRUE), drop = FALSE]
        }
      }
      return(ltb)
    }
  } else return(lmx)                                                            
} 


getData <- function(obj, ..., parameter = NULL, variable = NULL, 
  get.variable = NULL, get.parameter = NULL, merge.table = FALSE,
  remove_zero_dim = TRUE, drop = TRUE, astable = TRUE, use.dplyr = FALSE) {
  if (is.null(get.variable)) get.variable <- is.null(parameter)
  if (is.null(get.parameter)) get.parameter <- is.null(variable)
  if (merge.table && !astable) stop('merge is possible only for data.frame')
  if (get.parameter && get.variable) {
    if (!merge.table) {
      l1 <- getDataParameter(obj, ..., parameter = parameter, merge.table = FALSE,
        remove_zero_dim = remove_zero_dim, drop = drop, astable = astable)
      l2 <- getDataResult(obj, ..., variable = variable, merge.table = FALSE,
        remove_zero_dim = remove_zero_dim, drop = drop, astable = astable)
      for(i in names(l2)) l1[[i]] <- l2[[i]]
      return(l1)
    } else {
      l1 <- getDataParameter(obj, ..., parameter = parameter, merge.table = FALSE,
        remove_zero_dim = FALSE, drop = FALSE, astable = astable)
      l2 <- getDataResult(obj, ..., variable = variable, merge.table = FALSE,
        remove_zero_dim = FALSE, drop = FALSE, astable = astable)
      for(i in names(l2)) l1[[i]] <- l2[[i]]
      for(i in names(l1)) l1[[i]]$variable <- i
      if (use.dplyr) {
        l1 <- Reduce(function(x, y) {dplyr::full_join(x, y)}, l1)
      } else {
        l1 <- Reduce(function(x, y) {merge(x, y, all = TRUE)}, l1)
      }
      l1 <- l1[, c(colnames(l1)[colnames(l1) != 'value'], 'value'), drop = FALSE]
      if (remove_zero_dim) {
        l1 <- l1[l1[, 'value'] != 0,, drop = FALSE]
      }
      if (drop && ncol(l1) > 1) {
          l1 <- l1[, c(apply(l1[, -ncol(l1), drop = FALSE], 
            2, function(x) length(unique(x)) > 1), TRUE), drop = FALSE]
      }
      return(l1)
    }
  } else if (get.parameter) {
    return(getDataParameter(obj, ..., parameter = parameter, merge.table = merge.table,
      remove_zero_dim = remove_zero_dim, drop = drop, astable = astable, use.dplyr = use.dplyr)) 
  } else {
    return(getDataResult(obj, ..., variable = variable, merge.table = merge.table,
      remove_zero_dim = remove_zero_dim, drop = drop, astable = astable, use.dplyr = use.dplyr)) 
  }
}
  
getData_ <- function(obj, ..., parameter = NULL, variable = NULL, 
  get.variable = NULL, get.parameter = NULL, merge.table = FALSE,
  remove_zero_dim = TRUE, drop = TRUE, astable = TRUE, use.dplyr = FALSE) {
  psb_set <- c('tech', 'dem', 'sup', 'comm', 'group', 'region', 
    'year', 'slice', 'stg', 'expp', 'imp', 'trade')
  set <- list(...)                      
  if (any(!(names(set) %in% psb_set)))
    stop(paste('Unknown set name "', paste(names(set)[!(names(set) %in% psb_set)], 
      collapse = '", "'), '"', sep = ''))
  for(i in names(set)) {
    set[[i]] <-  grep(set[[i]], obj@result@set[[i]], value = TRUE)
  }
  getData(obj, args = set, 
      parameter = parameter, variable = variable, get.variable = get.variable, get.parameter = get.parameter, 
      merge.table = merge.table, remove_zero_dim = remove_zero_dim, drop = drop, astable = astable, use.dplyr = use.dplyr)
}

  
  
