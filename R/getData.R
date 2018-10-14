#' Performes search for available data in _scenario_ object.
#'
#' @param scen object _scenario_ with model solution
#' @param dataType type of data to lok for (currently only "parameters" and "variables")
#' @param dropEmpty logical, if TRUE drops parameters and variables with zero length
#' @param valueColumn logical, if TRUE will return variables and parameters with 'value' column (to filter sets and mappings)
#' @param dfDim logical, if TRUE returnes dimension _dim_
#' @param dfNames logical, whent TRUE regurnes names of the data frame column
#' @param asMatrix return results as a matric (not implemented)
#'
#' @return list with variables and parameters name, each includes _dim_ and _names_ character vectors.
#' @export
#'
#' @examples
findData <- function(scen, dataType = c("parameters", "variables"), 
                     setsNames_ = NULL, valueColumn = TRUE,
                     allSets = TRUE, # anyOfTheSets = !allSets,
                     dropEmpty = TRUE, dfDim = TRUE, dfNames = TRUE, asMatrix = FALSE) {
  
  ll <- list()
  lt <- list()
  
  #1 Parameters
  ii <- dataType == "parameters"
  if (any(ii)) {
    dataType <- dataType[!ii]
    dat <- scen@modInp@parameters
    lt <- lapply(dat, function(x) {
      if (dim(x@data)[1] > 0 || !dropEmpty) {
        list(
          dim = dim(x@data),
          names = names(x@data)
        )
      }
    })
  }
  ll <- c(ll, lt)
  
  #2. Variables
  ii <- dataType == "variables"
  if (any(ii)) {
    dataType <- dataType[!ii]
    dat <- scen@modOut@variables
    lt <- lapply(dat, function(x) {
      if (dim(x)[1] > 0 || !dropEmpty) {
        list(
          dim = if(dfDim) dim(x) else NULL,
          names = if(dfNames) names(x) else NULL
        )
      }
    })
    ll <- c(ll, lt)
  }
  
  if(valueColumn) {
    ii <- sapply(ll,function(x) any(grepl("^value$", x$names)))
    ll <- ll[ii]
  }
  
  # browser()
  if(length(setsNames_) > 0) {
    ii <- sapply(ll, function(x) {
      if (allSets) {
        all(sapply(setsNames_, function(y) any(grepl(y, x$names))))
      } else {
        any(sapply(setsNames_, function(y) any(grepl(y, x$names))))
      }
    })
    ll <- ll[ii]
  }

  if(length(dataType) > 0) warning("Data type '", dataType, "' is not found.")
  
  if (dropEmpty) {
    ii <- sapply(ll, is.null)
    ll <- ll[!ii]
  }
  return(ll)
}

#' Extracts information from _scenario_, based on filters.
#'
#' @param scen 
#' @param ... 
#' @param name 
#' @param parameters 
#' @param variables 
#' @param merge 
#' @param na.rm 
#' @param drop 
#' @param stringsAsFactors 
#' @param verbose 
#' @param asTibble 
#'
#' @return
#' @export
#'
#' @examples
getData <- function(scen, ..., name = NULL, parameters = TRUE, variables = TRUE, merge = FALSE, 
                    na.rm = FALSE, drop = FALSE, stringsAsFactors = FALSE, yearsAsFactors = FALSE, verbose = FALSE,
                    asTibble = TRUE, scenNameInList = as.logical(length(scen)-1)) {
  
  arg <- list(...)
  argnam <- names(arg)
  stopifnot(!any(duplicated(argnam)))
  # browser()
  # Select scenarios, check and add names if not provided
  if(!is.list(scen)) {
    scen <- list(scen)
    names(scen) <- scen[[1]]@name
  } else {
    ii <- sapply(scen, class) == "scenario"
    if (sum(ii) == 0) {
      message("Scenario object is not found")
      return(NULL)
    }
    scen <- scen[ii] # keep scenarios only
    nm <- names(scen)
    if(is.null(nm)) nm <- rep("", length(scen))
    ii <- nm == ""
    nm[ii] <- sapply(scen[ii], function(x) x@name) # work on names
    names(scen) <- nm
    ii <- duplicated(nm)
    if (any(ii)) {
      warning("Dropping duplicated scenarios: ", nm[ii])
      scen <- scen[!ii]
    }
  }
  
  # Identify filters
  ii <- grepl("name_", argnam)
  if (any(ii)) {
    if (!is.null(name)) stop("Duplicate parameter 'name' ('name_')")
    name_ <- arg[ii][[1]]
    arg <- arg[!ii]
  } else {
    name_ <- NULL
  }
  ii <- grepl("_$", names(arg))
  flt_ <- arg[ii]
  flt <- arg[!ii]
  # check for duplicates
  nflt <- names(flt)
  nflt_ <- names(flt_)
  nflt0 <- sub("_$", "", nflt_)
  ii <- (nflt %in% nflt0)
  if (any(ii)) stop("Duplicate parameters ", nflt_[ii])
  nflt1 <- c(nflt, nflt0)
  
  # Fishing for the data in scenarios
  ll <- list()
  parvar <- c(parameters = parameters, variables = variables)
  for (sc in names(scen)) { # loop over scenarios
    # Temporary solution for missing "comm" in "pDemand"
    # browser()
    if(is.null(scen[[sc]]@modInp@parameters$pDemand@data$comm)) {scen[[sc]] <- .addComm2pDemand(scen[[sc]])}
    for (datype in names(parvar)[parvar]) { # loop over data sources
      if (verbose) cat("Extracting data from", datype, "\n")
      lt <- findData(scen[[sc]], dataType = datype, setsNames_ = paste0("^", nflt1, "$"))
      pvNames <- names(lt)
      # filter for variable/parameter names
      if (!is.null(name)) {
        ii <- pvNames %in% name
        lt <- lt[ii]
      } else if (!is.null(name_)) {
        ii <- sapply(pvNames, function(x) {
          any(sapply(name_, function(y) grepl(y, x)))
        })
        lt <- lt[ii]
      }
      clNames <- unique(purrr::flatten_chr(lapply(lt, function(x) x$names))) # All par/var df-columns names
      # Filter for columns/sets
      if (length(nflt1) > 0 & length(clNames) > 0) {
        # Check if provided sets/filters exist
        ii <- nflt1 %in% clNames
        if (!all(ii)) warning("Sets '", paste(nflt1, collapse = "', '"), "' have not been found in scenario '", sc, "',", datype,"'.")
        # find all matching names of columns
        ii <- sapply(clNames, function (x) {any(grepl(x, nflt1))})
        clNames <- clNames[ii]
        # browser()
        if (length(clNames) == 0) {
          warning("Inconsistent combination of filters.")
          return(NULL)
        }
        # find pars/vars which have any of the col-names for filtration
        ii <- sapply(lt, function(x) {
          any(sapply(x$names, function(y) {any(grepl(y, clNames))}))
        })
        lt <- lt[ii]
      }
      pvNames <- names(lt)
      if (length(pvNames) == 0) {
        if (verbose) cat("No ", datype, " found for the selected set of filters, scenario '", sc, "'.\n", sep = "")
      } else {
        for (pv in pvNames) { # selected pars/vars
          if (datype == "parameters") {
            if (!is.null(scen[[sc]]@modInp@parameters[[pv]])) {
              dat <- scen[[sc]]@modInp@parameters[[pv]]@data
              if (verbose) cat("   ", pv, "\n")
            } else {
              warning("Parameter '", pv, "' was not found.")
            }
          } else {
            dat <- scen[[sc]]@modOut@variables[[pv]]
          }
          dim1 <- dim(dat)[1];
          if (is.null(dim1)) dim1 <- 0
          kk <- rep(TRUE, dim1)
          # browser()
          if (length(nflt1) > 0) { # the data should be filtered
            if (dim1 > 0) { # data exists
              prcl <- names(dat)
              prcl <- prcl[prcl %in% nflt1]
              for (st in prcl) { # selected sets (columns)
                cl_ <- nflt0[grepl(st, nflt_)] # regex match of sets names (find all comm* etc.) for regex match selection
                for (k in cl_) { # loop over sets for regex filtration
                  kk <- kk & grepl(flt_[[paste0(k, "_")]], dat[,k])
                }
                cl <- nflt[grepl(st, nflt)] # regex match of sets names (find all comm* etc.) for exact match selection
                for (k in cl) { # loop over sets/columns for exact filtration
                  kk2 <- rep(FALSE, length(kk))
                  for (h in flt[[k]]) { # loop over filtration vector
                    kk2 <- kk2 | (dat[,k] == h)
                  }
                  kk <- kk & kk2
                }
              }
            } else {
              if(verbose) cat("   ", pv, " has no data.\n")
            }
          }
          # browser()
          if (!is.null(dat[kk,, drop = FALSE]) && nrow(dat[kk,, drop = FALSE]) > 0) {
            nkk <- sum(kk)
            dat <- dplyr::bind_cols(data.frame(
              scenario = rep(sc, nkk), 
              name = rep(pv, nkk)), dat[kk,, drop = FALSE])
            le <- length(ll) + 1
            nm_ll <- names(ll)
            if (scenNameInList) nm_le <- paste(sc, pv, sep = ".") else nm_le <- pv
            ll[[le]] <- dat
            names(ll) <- c(nm_ll, nm_le)
          }
        }
      }
    }
  }
  
  ## Temporary solution for non-mileStone years data in parameters
  msy <- scen[[1]]@model@sysInfo@milestone$mid
  if (length(ll) > 0) {
    for (i in 1:length(ll)) {
      if (!is.null(ll[[i]]$year)) {
        ii <- ll[[i]]$year %in% msy # temporary solution
        if (!all(ii)) ll[[i]] <- ll[[i]][ii,] # temporary solution
      }
    }
  }
  
  # browser()
  if (merge) {
    if (length(ll) == 1) {
      dat <- ll[[1]]
    } else if (length(ll) > 1) {
      dat <- ll[[1]]
      for (i in 2:length(ll)) {
        suppressMessages(
          suppressWarnings(dat <- dplyr::full_join(dat, ll[[i]])))
      }
    } else {
      dat <- NULL
    }
    if (!is.null(dat)) {
      if(na.rm) {
        ii <- rowSums(apply(dat, 2, is.na))
        dat <- dat[!ii,]
      }
      if (stringsAsFactors) {
        for (i in 1:length(names(dat))) {
          if (is.character(dat[,i])) {dat[,i] <- as.factor(dat[,i])}
        }
      }
      if (!is.null(dat$year)) {
        # ii <- dat$year %in% msy # temporary solution
        # if (!all(ii)) dat <- dat[ii,] # temporary solution
        if (yearsAsFactors) {dat$year <- as.factor(dat$year)}
      }
      if (asTibble) {dat <- tibble::as_tibble(dat)}
    }
    return(dat)
  } else {
    if (length(ll) > 0) {
      for (i in 1:length(ll)) {
        if (!is.null(ll[[i]]$year)) {
          # ii <- ll[[i]]$year %in% msy # temporary solution
          # if (!all(ii)) ll[[i]] <- ll[[i]][ii,] # temporary solution
          if (yearsAsFactors) {ll[[i]]$year <- as.factor(ll[[i]]$year)}
        }
        if (stringsAsFactors) {
          colnam <- names(ll[[i]])[sapply(ll[[i]], is.character)]
          for (j in colnam) {
             ll[[i]][,j] <- as.factor(ll[[i]][,j])
          }
        }
        if (asTibble) ll[[i]] <- tibble::as_tibble(ll[[i]])
      }
    }
    return(ll)
  }
}

.addComm2pDemand <- function(scen) { # temporary
  dms <- unique(scen@modInp@parameters$pDemand@data$dem)
  scen@modInp@parameters$pDemand@data$comm <- NA
  for(demName in dms) {
    demComm <- scen@model@data$repository@data[[demName]]@commodity
    ii <- scen@modInp@parameters$pDemand@data$dem == demName
    scen@modInp@parameters$pDemand@data$comm[ii] <- demComm
  }
  sup <- unique(scen@modInp@parameters$sup@data$sup)
  # browser()
  scen@modInp@parameters$pSupAva@data$comm <- NA
  scen@modInp@parameters$pSupCost@data$comm <- NA
  scen@modInp@parameters$pSupReserve@data$comm <- NA
  for(supName in sup) {
    supComm <- scen@model@data$repository@data[[supName]]@commodity
    ii <- scen@modInp@parameters$pSupAva@data$sup == supName
    scen@modInp@parameters$pSupAva@data$comm[ii] <- supComm
    ii <- scen@modInp@parameters$pSupCost@data$sup == supName
    scen@modInp@parameters$pSupCost@data$comm[ii] <- supComm
    ii <- scen@modInp@parameters$pSupReserve@data$sup == supName
    scen@modInp@parameters$pSupReserve@data$comm[ii] <- supComm
  }
  
  return(scen)
}


#' #' Extraxts data from scenario object
#' #' 
#' #' obj objects of class scenario, model, or list with object of the two classes
#' #' 
#' #' \code{...} filters for searching data in the objects, which include:
#' #' @param obj object of class 'scenario' or list with objects of class scenario
#' #' @param parameter character vector with names of the model parameters
#' #' @param variable character vector with names of the model variables
#' #' @param tech character vector with names of tachnology objects
#' #' @param dem character vector with names of demand objects
#' #' @param sup character vector with names of sypply objects
#' #' @param comm character vector with names of commodity objects
#' #' @param group character vector group names in technology objects
#' #' @param region character vector with names of regions
#' #' @param year character or integer vector with years
#' #' @param slice character vector with names of slices
#' #' @param stg character vector with names of storage 
#' #' @param expp character vector with names of export processes
#' #' @param imp character vector with names of import processes
#' #' @param trade character vector with names of trade objects
#' #' @param get.parameter logical, if TRUE then search in interpolated parameters, and return if available  
#' #' @param get.variable logical, if TRUE then search in variables, and return if available  
#' #' @param zero.rm drop rows with zero values
#' #' @param drop logical, if TRUE (default) the minimal number of columns (dimensions) will be returned
#' #' @param regex logical, if FALSE or NULL (default), all of the parameters will be considered as character vectors, if TRUE all parameter inputs will be considered as regular expression strings (vectors are not allowed).
#' 
#' getData <- function(scen, ..., parameter = NULL, variable = NULL, 
#'                     get.parameter = NULL, get.variable = NULL, merge = FALSE,
#'                     zero.rm = TRUE, drop = TRUE, table = TRUE, use.dplyr = FALSE, 
#'                     stringsAsFactors = TRUE, yearsAsFactors = FALSE, name = NULL, ignore.case = FALSE, 
#'                     fixed = FALSE, useBytes = FALSE, invert = FALSE) {
#'   #, regex = FALSE
#'   # browser()
#'   psb_set <- c('tech', 'dem', 'sup', 'comm', 'group', 'region', 
#'                'year', 'slice', 'stg', 'expp', 'imp', 'trade', 'cns', 'src', 'dst')
#'   arg <- list(...) #, scenario(s) and 
#'   if (is.null(names(arg))) names(arg) <- rep('', length(arg))
#'   # if (any(names(arg) == 'parameters')) parameter <- arg$parameters
#'   # if (any(names(arg) == 'variables')) variable <- arg$variables
#'   # if (any(names(arg) == 'get.variables')) get.variable <- arg$get.variables
#'   # if (any(names(arg) == 'get.parameters')) get.parameter <- arg$get.parameters
#'   # arg <- arg[!(names(arg) %in% c('get.parameters', 'parameters', 'variables', 'get.variables'))]
#'   while (any(sapply(arg, function(x) is.list(x) && all(sapply(x, class) == 'scenario')))) {
#'     fl <- seq(along = arg)[sapply(arg, function(x) is.list(x) && all(sapply(x, class) == 'scenario'))]
#'     scen <- arg[[fl]]
#'     arg <- arg[-fl]
#'     for(i in seq(along = scen))
#'       arg[[length(arg) + 1]] <- scen[[i]]
#'   }
#'   set <- arg[names(arg) %in% c(psb_set, paste(psb_set, '_', sep = ''))]      
#'   arg <- arg[!(names(arg) %in% names(set))]
#'   if (any(names(arg) == 'regex')) {
#'     regex <- arg$regex
#'     arg <- arg[names(arg) != 'regex']
#'     if (any(grep('_$', names(set)))) {
#'       ff <- grep('_$', names(set), value = TRUE)
#'       f2 <- gsub('_$', '', ff); names(f2) <- ff
#'       warning(paste('Duplicated arguments: "', paste(ff, collapse = '", "'), 
#'                     '", and: "',f2, '"', sep = ''))
#'       for(i in ff) {
#'         set[[f2[i]]] <- c(set[[f2[i]]] , set[[i]])
#'       }
#'     }
#'     if (regex) {
#'       names(set) <- paste(names(set), '_', sep = '')
#'     }
#'   } 
#'   energyRt:::.getData1(arg = arg, set = set, name = name, parameter = parameter, variable = variable, 
#'                        get.parameter = get.parameter, 
#'                        get.variable = get.variable, merge = merge, zero.rm = zero.rm, drop = drop, 
#'                        table = table, use.dplyr = use.dplyr, stringsAsFactors = stringsAsFactors, 
#'                        yearsAsFactors = yearsAsFactors, 
#'                        ignore.case = ignore.case, fixed = fixed, useBytes = useBytes, invert = invert)
#' }
#' 
#' #
#' 
#' getData_ <- function(..., parameter = NULL, variable = NULL, 
#'                      get.parameter = NULL, get.variable = NULL, merge = FALSE,
#'                      zero.rm = TRUE, drop = TRUE, table = TRUE, use.dplyr = FALSE, 
#'                      stringsAsFactors = TRUE, yearsAsFactors = FALSE, name = NULL, ignore.case = FALSE, 
#'                      fixed = FALSE, useBytes = FALSE, invert = FALSE) {
#'   getData(..., parameter = parameter, variable = variable, 
#'           get.parameter = get.parameter, get.variable = get.variable, merge = merge,
#'           zero.rm = zero.rm, drop = drop, table = table, use.dplyr = use.dplyr, 
#'           stringsAsFactors = stringsAsFactors, yearsAsFactors = yearsAsFactors, name = name, 
#'           ignore.case = ignore.case, fixed = fixed, useBytes = useBytes, invert = invert)
#' }
#' 
#' 
#' .getData0 <- function(obj, set, parameter = NULL, variable = NULL, 
#'                      get.parameter = NULL, get.variable = NULL, merge = FALSE,
#'                      zero.rm = TRUE, drop = TRUE, table = TRUE, use.dplyr = FALSE, 
#'                      stringsAsFactors = TRUE, yearsAsFactors = FALSE, scenario.name = NULL, 
#'                      ignore.case = FALSE, fixed = FALSE, useBytes = FALSE, invert = FALSE) {
#'   # Find set
#'   psb_set <- c('tech', 'dem', 'sup', 'comm', 'group', 'region', 
#'                'year', 'slice', 'stg', 'expp', 'imp', 'trade', 'cns', 'src', 'dst')
#'   src_set <- obj@modOut@sets[psb_set]
#'   psb_set2 <- paste(psb_set, '_', sep = '')
#'   psb_set3 <- c(psb_set, psb_set2)
#'   if (any(!(names(set) %in% psb_set3))) {
#'     stop(paste('Unknown set(s): "', paste(names(set)[!(names(set) %in% psb_set3)], collapse = '", "'),  '"', sep = ''))
#'   }
#'   # Conver regular express set
#'   if (any(names(set) %in% psb_set2)) {
#'     ii <- names(set)[names(set) %in% psb_set2]; i2 <- gsub('[_]$', '', ii); names(i2) <- ii;
#'     for(i in ii) {
#'       xx <- unique(c(lapply(set[[i]], function(x) grep(x, src_set[[i2[i]]], value = TRUE, 
#'        ignore.case = ignore.case, fixed = fixed, useBytes = useBytes, invert = invert)), recursive = TRUE))
#'       if (length(xx) > 0) set[[i2[i]]] <- c(set[[i2[i]]], xx)
#'     }
#'     set <- set[!(names(set) %in% ii)]
#'   }
#'   for(i in names(set)) {
#'     if (any(!(set[[i]] %in% src_set[[i]]))) 
#'       stop(paste('Unknown set "', i, '" value(s) : "', 
#'                   paste(set[[i]][!(set[[i]] %in% src_set[[i]])], collapse = '", "'),  '"', sep = ''))
#'     set[[i]] <- unique(set[[i]])
#'     if (length(set[[i]]) == length(src_set[[i]])) set[[i]] <- NULL
#'   }
#'   # Alias rule for remove set
#'   alias_set <- lapply(psb_set, function(x) x)
#'   names(alias_set) <- alias_set
#'   alias_set$comm = c('comm', 'acomm', 'comme', 'commp')
#'   alias_set$region = c('region', 'regionp', 'src', 'dst')
#'   if (any(names(set) %in% c('src', 'dst'))) {
#'     alias_set$region <- c('region', 'regionp')
#'   } 
#'   alias_set$year = c('year', 'yearp', 'yeare')
#'   alias_set <- alias_set[names(set)]  
#'   # Function for remove variable (and value)
#'   if (is.null(set)) {
#'     check_function <- function(vl) vl
#'   } else {
#'     check_function <- function(vl) {
#'       if (!is.data.frame(vl) ||  nrow(vl) == 0) return(NULL)
#'       # String for speeds for : How many times set include in table
#'       use_set <- sapply(alias_set, function(x) sum(colnames(vl) %in% x)) 
#'       if (any(use_set == 0)) return(NULL)
#'       names(use_set) <- names(alias_set)
#'       use_set <- use_set[!sapply(set, is.null)]
#'       for(j in names(use_set)) {
#'         if (use_set[j] == 1) {
#'             vl <- vl[vl[, colnames(vl) %in% alias_set[[j]]] %in% set[[j]],, drop = FALSE]
#'         } else {
#'           vl <- vl[apply(apply(vl[vl[, colnames(vl) %in% alias_set[[j]]] %in% set[[j]],, drop = FALSE], 2, 
#'                                function(x) x %in% set[[j]]), 1, any),, drop = FALSE]
#'         }
#'         if (nrow(vl) == 0) return(NULL)
#'       }
#'       vl
#'     }
#'   }
#'   # Variable
#'   if (is.null(get.variable)) get.variable <- is.null(parameter) || !is.null(variable)
#'   if (is.null(get.parameter)) get.parameter <- is.null(variable) || !is.null(parameter)
#'   res <- list()
#'   if (get.variable) {
#'     dtt <- obj@modOut@variables
#'     if (!is.null(variable)) {
#'       if (any(!(variable %in% names(dtt)))) 
#'         stop(paste('getData: unknown argument: "', paste(variable[!(variable %in% names(dtt))], 
#'                                                          collapse = '", "'), '"', sep = ''))
#'       dtt <- dtt[variable]
#'     }
#'     for(i in names(dtt)) {
#'       res[[i]] <- check_function(dtt[[i]])
#'     }
#'   }
#'   # Parameter
#'   if (get.parameter) {
#'     fl <- names(obj@modInp@parameters)[sapply(obj@modInp@parameters, function(x) 
#'       x@type %in% c('simple', 'multi'))]
#'     if (!is.null(parameter)) {
#'       if (any(!(parameter %in% fl))) 
#'         stop(paste('getData: unknown argument: "', paste(parameter[!(parameter %in% fl)], 
#'                                                          collapse = '", "'), '"', sep = ''))
#'       fl <- fl[fl %in% parameter]
#'     }
#'     dtt <- obj@modInp@parameters[fl]
#'     for(i in names(dtt)) {
#'       res[[i]] <- check_function(dtt[[i]]@data)
#'     }
#'   }
#'   res <- res[!sapply(res, is.null)]
#'   if (zero.rm) {
#'     for(i in names(res)) {
#'       res[[i]] <- res[[i]][res[[i]]$value != 0,, drop = FALSE]
#'     }
#'     res <- res[!sapply(res, is.null) & sapply(res, nrow) != 0]
#'   }
#'   # To table
#'   if (!table) {
#'     if (drop) {
#'       for(i in names(res)) {
#'         res[[i]] <- res[[i]][, c(colnames(res[[i]][, -ncol(res[[i]]), drop = FALSE]) == 'scen' |
#'             apply(res[[i]][, -ncol(res[[i]]), drop = FALSE], 2, function(x) any(x[1] != x)), TRUE), drop = FALSE]
#'       }
#'     }
#'     for(i in names(res)) {
#'       res[[i]] <- tapply(res[[i]]$value, res[[i]][, -ncol(res[[i]]), drop = FALSE], sum)
#'       res[[i]][is.na(res[[i]])] <- 0 
#'     }
#'     res <- res[sapply(res, length) != 0]
#'     if (length(res) == 0) return(NULL)
#'   } else {
#'     # table
#'     if (merge) {
#'       for(i in names(res)) {
#'         res[[i]] <- cbind(name = rep(i, nrow(res[[i]])), res[[i]], stringsAsFactors = FALSE)
#'       }
#'       if (length(res) == 0) return(NULL)
#'       if (length(res) > 1) {
#'         if (use.dplyr) {
#'           res <- Reduce(function(x, y) {dplyr::full_join(x, y)}, res)
#'         } else {
#'           res <- Reduce(function(x, y) {merge(x, y, all = TRUE)}, res)
#'         }
#'         res <- cbind(res[, colnames(res) != 'value', drop = FALSE], value = res$value, stringsAsFactors = FALSE)
#'       } else res <- res[[1]]
#'       if (drop) {
#'           res <- res[, c(TRUE, TRUE[any(colnames(res) == 'scen')],  
#'                          apply(res[, -c(1, 2[any(colnames(res) == 'scen')], ncol(res)), drop = FALSE], 2, 
#'                                          function(x) length(unique(x)) != 1), TRUE), drop = FALSE]
#'       }
#'       if (stringsAsFactors) {
#'         cc <- colnames(res)[sapply(res, class) == 'character' & !(colnames(res) %in% c('scen', 'name'))]
#'         for(i in cc) {
#'           res[, i] <- factor(res[, i], levels = obj@modOut@sets[[i]])
#'         }
#'         if (!is.null(scenario.name)) {
#'           res$scen <- factor(res[, 'scen'], levels = scenario.name)
#'         }
#'         res$name <- as.factor(res$name)
#'       }
#'       if (yearsAsFactors) {
#'         cc <- colnames(res)[sapply(res, class) == 'numeric' & !(colnames(res) %in% c('value'))]
#'         for(i in cc) {
#'           res[, i] <- factor(res[, i], levels = obj@modOut@sets[[i]])
#'         }
#'       }
#'     } else {
#'       # table & !merge
#'       for(i in names(res)) {
#'         if (drop) {
#'             res[[i]] <- res[[i]][, c(colnames(res[[i]][, -ncol(res[[i]]), drop = FALSE]) == 'scen' |
#'                 apply(res[[i]][, -ncol(res[[i]]), drop = FALSE], 2, function(x) length(unique(x)) != 1), TRUE), drop = FALSE]
#'         }
#'         if (stringsAsFactors) {
#'           cc <- colnames(res[[i]])[sapply(res[[i]], class) == 'character' & !(colnames(res[[i]]) %in% 'scen')]
#'           for(j in cc) {
#'             res[[i]][, j] <- factor(res[[i]][, j], levels = obj@modOut@sets[[j]])
#'           }
#'           if (!is.null(scenario.name)) {
#'             res[[i]]$scen <- factor(res[[i]][, 'scen'], levels = scenario.name)
#'           }
#'         }
#'         if (yearsAsFactors) {
#'           cc <- colnames(res[[i]])[sapply(res[[i]], class) == 'numeric' & !(colnames(res[[i]]) %in% c('value'))]
#'           for(j in cc) {
#'             res[[i]][, j] <- factor(res[[i]][, j], levels = obj@modOut@sets[[j]])
#'           }
#'         }    
#'       }
#'       if (length(res) == 0) return(NULL)
#'     }
#'   }
#'   res
#' }
#'  
#' .getData1 <- function(arg, set, parameter = NULL, variable = NULL, 
#'                      get.parameter = NULL, get.variable = NULL, merge = FALSE,
#'                      zero.rm = TRUE, drop = TRUE, table = TRUE, use.dplyr = FALSE, 
#'                      stringsAsFactors = TRUE, yearsAsFactors = FALSE, scenario.name = NULL, name = NULL, 
#'                      ignore.case = FALSE, fixed = FALSE, useBytes = FALSE, invert = FALSE) {
#'   if (any(sapply(arg, class) != 'scenario')) {
#'     ss <- names(arg)[sapply(arg, class) != 'scenario']
#'     stop(paste('getData: unknown argument: "', paste(ss, collapse = '", "'), '"', sep = ''))
#'   }
#'   if (length(arg) != 1) {
#'     scenario.name <- sapply(arg, function(x) x@name)
#'     for(j in names(arg[[1]]@modInp@parameters)) {
#'       if (arg[[1]]@modInp@parameters[[j]]@type == 'set') {
#'         hh <- unique(c(lapply(arg, function(x) x@modInp@parameters[[j]]@data[, 1]), recursive = TRUE))
#'         if (length(hh) != 0) {
#'           arg[[1]]@modInp@parameters[[j]]@data[seq(along = hh), ] <- NA
#'           arg[[1]]@modInp@parameters[[j]]@data <- arg[[1]]@modInp@parameters[[j]]@data[seq(along = hh),, drop = FALSE] 
#'           arg[[1]]@modInp@parameters[[j]]@data[, 1] <- hh
#'           if (arg[[1]]@modInp@parameters[[j]]@nValues != -1)
#'             arg[[1]]@modInp@parameters[[j]]@nValues <- length(hh)
#'         }
#'       } else if (arg[[1]]@modInp@parameters[[j]]@type %in% c('simple', 'multi')) {
#'         for(i in seq(length.out = length(arg))) {
#'           arg[[i]]@modInp@parameters[[j]]@data <- cbind(
#'               scen = rep(arg[[i]]@name, nrow(arg[[i]]@modInp@parameters[[j]]@data)),
#'                          arg[[i]]@modInp@parameters[[j]]@data, stringsAsFactors = FALSE)
#'           if (i != 1) arg[[1]]@modInp@parameters[[j]]@data <- 
#'               rbind(arg[[1]]@modInp@parameters[[j]]@data, arg[[i]]@modInp@parameters[[j]]@data)
#'         }
#'       }
#'     }
#'     for(j in names(arg[[1]]@modOut@variables)) {
#'       for(i in seq(length.out = length(arg))) {
#'         arg[[i]]@modOut@variables[[j]] <- cbind(scen = rep(arg[[i]]@name, nrow(arg[[i]]@modOut@variables[[j]])),
#'           arg[[i]]@modOut@variables[[j]], stringsAsFactors = FALSE)
#'         if (i != 1) arg[[1]]@modOut@variables[[j]] <- 
#'             rbind(arg[[1]]@modOut@variables[[j]], arg[[i]]@modOut@variables[[j]])
#'       }
#'     }
#'     obj <- arg[[1]]
#'   } else {
#'     scenario.name <- NULL
#'     obj <- arg[[1]]
#'     if (class(obj) != 'scenario') stop('Wrong argument obj')
#'   }
#'   if (!is.null(name)) {
#'     parameter <- c(parameter, name[name %in% names(obj@modInp@parameters)])
#'     variable <- c(variable, name[name %in% names(obj@modOut@variables)])
#'     ff <- name[!(name %in% c(names(obj@modInp@parameters), names(obj@modOut@variables)))]
#'     if (length(ff) != 0) {
#'       stop(paste('There is unknown name: "', paste(ff, collapse = '", "'), '"', sep = ''))
#'     }
#'   }
#'   energyRt:::.getData0(obj, set = set, parameter = parameter, variable = variable, get.parameter = get.parameter, 
#'            get.variable = get.variable, merge = merge, zero.rm = zero.rm, drop = drop, 
#'            table = table, use.dplyr = use.dplyr, stringsAsFactors = stringsAsFactors, 
#'            yearsAsFactors = yearsAsFactors, scenario.name = scenario.name, 
#'            ignore.case = ignore.case, fixed = fixed, useBytes = useBytes, invert = invert)
#'     
#' }
#' 
