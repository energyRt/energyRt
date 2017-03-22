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
#' @param remove_zero_dim rename to 'zero.rm' 
#' @param drop # add 'drop.zero.dim = drop' and 'remove_zero_dim = drop'
 

getData0 <- function(obj, set, parameter = NULL, variable = NULL, 
                     get.parameter = NULL, get.variable = NULL, merge = FALSE,
                     zero.rm = TRUE, drop = TRUE, table = TRUE, use.dplyr = FALSE, 
                     stringsAsFactors = TRUE, yearsAsFactors = FALSE, scenario.name = NULL) {
  # Find set
  psb_set <- c('tech', 'dem', 'sup', 'comm', 'group', 'region', 
               'year', 'slice', 'stg', 'expp', 'imp', 'trade', 'cns', 'src', 'dst')
  src_set <- obj@modOut@sets[psb_set]
  psb_set2 <- paste(psb_set, '_', sep = '')
  psb_set3 <- c(psb_set, psb_set2)
  if (any(!(names(set) %in% psb_set3))) {
    stop(paste('Unknown set(s): "', paste(names(set)[!(names(set) %in% psb_set3)], collapse = '", "'),  '"', sep = ''))
  }
  # Conver regular express set
  if (any(names(set) %in% psb_set2)) {
    ii <- names(set)[names(set) %in% psb_set2]; i2 <- gsub('[_]$', '', ii); names(i2) <- ii;
    for(i in ii) {
      xx <- unique(c(lapply(set[[i]], function(x) grep(x, src_set[[i2[i]]], value = TRUE)), recursive = TRUE))
      if (length(xx) > 0) set[[i2[i]]] <- c(set[[i2[i]]], xx)
    }
    set <- set[!(names(set) %in% ii)]
  }
  for(i in names(set)) {
    if (any(!(set[[i]] %in% src_set[[i]]))) 
      stop(paste('Unknown set "', i, '" value(s) : "', 
                  paste(set[[i]][!(set[[i]] %in% src_set[[i]])], collapse = '", "'),  '"', sep = ''))
    set[[i]] <- unique(set[[i]])
    if (length(set[[i]]) == length(src_set[[i]])) set[[i]] <- NULL
  }
  # Alias rule for remove set
  alias_set <- lapply(psb_set, function(x) x)
  names(alias_set) <- alias_set
  alias_set$comm = c('comm', 'acomm', 'comme')
  alias_set$region = c('region', 'regionp', 'src', 'dst')
  if (any(names(set) %in% c('src', 'dst'))) {
    alias_set$region <- c('region', 'regionp')
  } 
  alias_set$year = c('year', 'yearp', 'yeare')
  alias_set <- alias_set[names(set)]  
  # Function for remove variable (and value)
  if (is.null(set)) {
    check_function <- function(vl) vl
  } else {
    check_function <- function(vl) {
      if (!is.data.frame(vl) ||  nrow(vl) == 0) return(NULL)
      # String for speeds for : How many times set include in table
      use_set <- sapply(alias_set, function(x) sum(colnames(vl) %in% x)) 
      if (any(use_set == 0)) return(NULL)
      names(use_set) <- names(alias_set)
      use_set <- use_set[!sapply(set, is.null)]
      for(j in names(use_set)) {
        if (use_set[j] == 1) {
            vl <- vl[vl[, colnames(vl) %in% alias_set[[j]]] %in% set[[j]],, drop = FALSE]
        } else {
          vl <- vl[apply(apply(vl[vl[, colnames(vl) %in% alias_set[[j]]] %in% set[[j]],, drop = FALSE], 2, 
                               function(x) x %in% set[[j]]), 1, any),, drop = FALSE]
        }
        if (nrow(vl) == 0) return(NULL)
      }
      vl
    }
  }
  # Variable
  if (is.null(get.variable)) get.variable <- is.null(parameter) || !is.null(variable)
  if (is.null(get.parameter)) get.parameter <- is.null(variable) || !is.null(parameter)
  res <- list()
  if (get.variable) {
    dtt <- obj@modOut@variables
    if (!is.null(variable)) {
      if (any(!(variable %in% names(dtt)))) 
        stop(paste('getData: unknown argument: "', paste(variable[!(variable %in% names(dtt))], 
                                                         collapse = '", "'), '"', sep = ''))
      dtt <- dtt[variable]
    }
    for(i in names(dtt)) {
      res[[i]] <- check_function(dtt[[i]])
    }
  }
  # Parameter
  if (get.parameter) {
    fl <- names(obj@modInp@parameters)[sapply(obj@modInp@parameters, function(x) 
      x@type %in% c('simple', 'multi'))]
    if (!is.null(parameter)) {
      if (any(!(parameter %in% fl))) 
        stop(paste('getData: unknown argument: "', paste(parameter[!(parameter %in% fl)], 
                                                         collapse = '", "'), '"', sep = ''))
      fl <- fl[fl %in% parameter]
    }
    dtt <- obj@modInp@parameters[fl]
    for(i in names(dtt)) {
      res[[i]] <- check_function(dtt[[i]]@data)
    }
  }
  res <- res[!sapply(res, is.null)]
  if (zero.rm) {
    for(i in names(res)) {
      res[[i]] <- res[[i]][res[[i]]$value != 0,, drop = FALSE]
    }
    res <- res[!sapply(res, is.null) & sapply(res, nrow) != 0]
  }
  # To table
  if (!table) {
    if (drop) {
      for(i in names(res)) {
        res[[i]] <- res[[i]][, c(colnames(res[[i]][, -ncol(res[[i]]), drop = FALSE]) == 'scen' |
            apply(res[[i]][, -ncol(res[[i]]), drop = FALSE], 2, function(x) any(x[1] != x)), TRUE), drop = FALSE]
      }
    }
    for(i in names(res)) {
      res[[i]] <- tapply(res[[i]]$value, res[[i]][, -ncol(res[[i]]), drop = FALSE], sum)
      res[[i]][is.na(res[[i]])] <- 0 
    }
    res <- res[sapply(res, length) != 0]
    if (length(res) == 0) return(NULL)
  } else {
    # table
    if (merge) {
      for(i in names(res)) {
        res[[i]] <- cbind(name = rep(i, nrow(res[[i]])), res[[i]], stringsAsFactors = FALSE)
      }
      if (length(res) == 0) return(NULL)
      if (length(res) > 1) {
        if (use.dplyr) {
          res <- Reduce(function(x, y) {dplyr::full_join(x, y)}, res)
        } else {
          res <- Reduce(function(x, y) {merge(x, y, all = TRUE)}, res)
        }
        res <- cbind(res[, colnames(res) != 'value', drop = FALSE], value = res$value, stringsAsFactors = FALSE)
      } else res <- res[[1]]
      if (drop) {
          res <- res[, c(TRUE, TRUE[any(colnames(res) == 'scen')], 
                         apply(res[, -c(1, 2[any(colnames(res) == 'scen')], ncol(res)), drop = FALSE], 2, 
                                         function(x) length(unique(x)) != 1), TRUE), drop = FALSE]
      }
      if (stringsAsFactors) {
        cc <- colnames(res)[sapply(res, class) == 'character' & !(colnames(res) %in% c('scen', 'name'))]
        for(i in cc) {
          res[, i] <- factor(res[, i], levels = obj@modOut@sets[[i]])
        }
        if (!is.null(scenario.name)) {
          res$scen <- factor(res[, 'scen'], levels = scenario.name)
        }
        res$name <- as.factor(res$name)
      }
      if (yearsAsFactors) {
        cc <- colnames(res)[sapply(res, class) == 'numeric' & !(colnames(res) %in% c('value'))]
        for(i in cc) {
          res[, i] <- factor(res[, i], levels = obj@modOut@sets[[i]])
        }
      }
    } else {
      # table & !merge
      for(i in names(res)) {
        if (drop) {
            res[[i]] <- res[[i]][, c(colnames(res[[i]][, -ncol(res[[i]]), drop = FALSE]) == 'scen' |
                apply(res[[i]][, -ncol(res[[i]]), drop = FALSE], 2, function(x) length(unique(x)) != 1), TRUE), drop = FALSE]
        }
        if (stringsAsFactors) {
          cc <- colnames(res[[i]])[sapply(res[[i]], class) == 'character' & !(colnames(res[[i]]) %in% 'scen')]
          for(j in cc) {
            res[[i]][, j] <- factor(res[[i]][, j], levels = obj@modOut@sets[[j]])
          }
          if (!is.null(scenario.name)) {
            res[[i]]$scen <- factor(res[[i]][, 'scen'], levels = scenario.name)
          }
        }
        if (yearsAsFactors) {
          cc <- colnames(res[[i]])[sapply(res[[i]], class) == 'numeric' & !(colnames(res[[i]]) %in% c('value'))]
          for(j in cc) {
            res[[i]][, j] <- factor(res[[i]][, j], levels = obj@modOut@sets[[j]])
          }
        }    
      }
      if (length(res) == 0) return(NULL)
    }
  }
  res
}
 
getData1 <- function(arg, set, parameter = NULL, variable = NULL, 
                     get.parameter = NULL, get.variable = NULL, merge = FALSE,
                     zero.rm = TRUE, drop = TRUE, table = TRUE, use.dplyr = FALSE, 
                     stringsAsFactors = TRUE, yearsAsFactors = FALSE, scenario.name = NULL, name = NULL) {
  if (any(sapply(arg, class) != 'scenario')) {
    ss <- names(arg)[sapply(arg, class) != 'scenario']
    stop(paste('getData: unknown argument: "', paste(ss, collapse = '", "'), '"', sep = ''))
  }
  if (length(arg) != 1) {
    scenario.name <- sapply(arg, function(x) x@name)
    for(j in names(arg[[1]]@modInp@parameters)) {
      if (arg[[1]]@modInp@parameters[[j]]@type == 'set') {
        hh <- unique(c(lapply(arg, function(x) x@modInp@parameters[[j]]@data[, 1]), recursive = TRUE))
        if (length(hh) != 0) {
          arg[[1]]@modInp@parameters[[j]]@data[seq(along = hh), ] <- NA
          arg[[1]]@modInp@parameters[[j]]@data <- arg[[1]]@modInp@parameters[[j]]@data[seq(along = hh),, drop = FALSE] 
          arg[[1]]@modInp@parameters[[j]]@data[, 1] <- hh
          if (arg[[1]]@modInp@parameters[[j]]@nValues != -1)
            arg[[1]]@modInp@parameters[[j]]@nValues <- length(hh)
        }
      } else if (arg[[1]]@modInp@parameters[[j]]@type %in% c('simple', 'multi')) {
        for(i in seq(length.out = length(arg))) {
          arg[[i]]@modInp@parameters[[j]]@data <- cbind(
              scen = rep(arg[[i]]@name, nrow(arg[[i]]@modInp@parameters[[j]]@data)),
                         arg[[i]]@modInp@parameters[[j]]@data, stringsAsFactors = FALSE)
          if (i != 1) arg[[1]]@modInp@parameters[[j]]@data <- 
              rbind(arg[[1]]@modInp@parameters[[j]]@data, arg[[i]]@modInp@parameters[[j]]@data)
        }
      }
    }
    for(j in names(arg[[1]]@modOut@variables)) {
      for(i in seq(length.out = length(arg))) {
        arg[[i]]@modOut@variables[[j]] <- cbind(scen = rep(arg[[i]]@name, nrow(arg[[i]]@modOut@variables[[j]])),
          arg[[i]]@modOut@variables[[j]], stringsAsFactors = FALSE)
        if (i != 1) arg[[1]]@modOut@variables[[j]] <- 
            rbind(arg[[1]]@modOut@variables[[j]], arg[[i]]@modOut@variables[[j]])
      }
    }
    obj <- arg[[1]]
  } else {
    scenario.name <- NULL
    obj <- arg[[1]]
    if (class(obj) != 'scenario') stop('Wrong argument obj')
  }
  if (!is.null(name)) {
    parameter <- c(parameter, name[name %in% names(obj@modInp@parameters)])
    variable <- c(variable, name[name %in% names(obj@modOut@variables)])
    ff <- name[!(name %in% c(names(obj@modInp@parameters), names(obj@modOut@variables)))]
    if (length(ff) != 0) {
      stop(paste('There is unknown name: "', paste(ff, collapse = '", "'), '"', sep = ''))
    }
  }
  getData0(obj, set = set, parameter = parameter, variable = variable, get.parameter = get.parameter, 
           get.variable = get.variable, merge = merge, zero.rm = zero.rm, drop = drop, 
           table = table, use.dplyr = use.dplyr, stringsAsFactors = stringsAsFactors, 
           yearsAsFactors = yearsAsFactors, scenario.name = scenario.name)
    
}

getData <- function(..., parameter = NULL, variable = NULL, 
                     get.parameter = NULL, get.variable = NULL, merge = FALSE,
                     zero.rm = TRUE, drop = TRUE, table = TRUE, use.dplyr = FALSE, 
                     stringsAsFactors = TRUE, yearsAsFactors = FALSE, name = NULL) {
  #, regex = FALSE
  psb_set <- c('tech', 'dem', 'sup', 'comm', 'group', 'region', 
               'year', 'slice', 'stg', 'expp', 'imp', 'trade', 'cns', 'src', 'dst')
  arg <- list(...) #, set
  if (is.null(names(arg))) names(arg) <- rep('', length(arg))
  if (any(names(arg) == 'parameters')) parameter <- arg$parameters
  if (any(names(arg) == 'variables')) variable <- arg$variables
  if (any(names(arg) == 'get.variables')) get.variable <- arg$get.variables
  if (any(names(arg) == 'get.parameters')) get.parameter <- arg$get.parameters
  arg <- arg[!(names(arg) %in% c('get.parameters', 'parameters', 'variables', 'get.variables'))]
  if (any(names(arg) == 'scenario' && is.list(arg$scenario))) {
    fl <- seq(along = arg)[names(arg) == 'scenario']
    for(i in seq(length.out = arg$scenario))
      arg[[length(arg) + 1]] <- arg$scenario[[i]]
    arg <- arg[-fl]
  }
  set <- arg[names(arg) %in% c(psb_set, paste(psb_set, '_', sep = ''))]      
  arg <- arg[!(names(arg) %in% names(set))]
  if (any(names(arg) == 'regex')) {
    regex <- arg$regex
    arg <- arg[names(arg) != 'regex']
    if (any(grep('_$', names(set)))) {
      ff <- grep('_$', names(set), value = TRUE)
      f2 <- gsub('_$', '', ff); names(f2) <- ff
      warning(paste('There are unapropriayte set with define "regex" argument: "', paste(ff, collapse = '", "'), 
                    '", that merge with : "',f2, '"', sep = ''))
        for(i in ff) {
          set[[f2[i]]] <- c(set[[f2[i]]] , set[[i]])
          }
    }
    if (regex) {
      names(set) <- paste(names(set), '_', sep = '')
    }
  } 
  getData1(arg = arg, set = set, name = name, parameter = parameter, variable = variable, get.parameter = get.parameter, 
           get.variable = get.variable, merge = merge, zero.rm = zero.rm, drop = drop, 
           table = table, use.dplyr = use.dplyr, stringsAsFactors = stringsAsFactors, 
           yearsAsFactors = yearsAsFactors)
}

getData_ <- function(..., parameter = NULL, variable = NULL, 
                    get.parameter = NULL, get.variable = NULL, merge = FALSE,
                    zero.rm = TRUE, drop = TRUE, table = TRUE, use.dplyr = FALSE, 
                    stringsAsFactors = TRUE, yearsAsFactors = FALSE, name = NULL) {
  getData(..., parameter = parameter, variable = variable, 
                       get.parameter = get.parameter, get.variable = get.variable, merge = merge,
                       zero.rm = zero.rm, drop = drop, table = table, use.dplyr = use.dplyr, 
                       stringsAsFactors = stringsAsFactors, yearsAsFactors = yearsAsFactors, name = name)
}
  

