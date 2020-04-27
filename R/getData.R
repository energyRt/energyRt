#' Performes search for available data in _scenario_ object.
#'
#' @param scen object _scenario_ with model solution.
#' @param dataType type of data to lok for (currently only "parameters" and "variables").
#' @param dropEmpty logical, if TRUE drops parameters and variables with zero length.
#' @param valueColumn logical, if TRUE will return variables and parameters with 'value' column (to filter sets and mappings).
#' @param dfDim logical, if TRUE returns dimension _dim_.
#' @param dfNames logical, when TRUE returns names of the data frame column.
#' @param asMatrix return results as a matric (not implemented).
#' @param setsNames_ regular expression pattern for names of sets which will be included in search.
#' @param allSets logical, if TRUE _and_ operator should be used in search the sets, _or_ will be used if FALSE.
#' @param ignore.case grepl parameter for matchin names.
#'
#' @return list with variables and parameters name, each includes _dim_ and _names_ character vectors.
#'
findData <- function(scen, dataType = c("parameters", "variables"), 
                     setsNames_ = NULL, valueColumn = TRUE,
                     allSets = TRUE, ignore.case = FALSE, # anyOfTheSets = !allSets,
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
    ii <- sapply(ll,function(x) any(grepl("^value$", x$names, ignore.case = ignore.case)))
    ll <- ll[ii]
  }
  
  # browser()
  if(length(setsNames_) > 0) {
    ii <- sapply(ll, function(x) {
      if (allSets) {
        all(sapply(setsNames_, function(y) any(grepl(y, x$names, ignore.case = ignore.case))))
      } else {
        any(sapply(setsNames_, function(y) any(grepl(y, x$names, ignore.case = ignore.case))))
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

#' Extracts information from scenario objects, based on filters.
#'
#' @param scen Object scenario or list with scenarios.
#' @param ... filters for various sets (setname = c(val1, val2) or setname_ = "matching pattern"), see details.
#' @param name character vector with names of parameters and/or variables.
#' @param merge if TRUE, the search results will be merged in one dataframe; the named list will be returned if FALSE.
#' @param process if TRUE, dimensions "tech", "stg", "trade", "imp", "expp", "dem", and "sup" will be renamed with "process".
#' @param parameters if TRUE, parameters will be included in the search and returned if found.
#' @param variables if TRUE, variables will be included in the search and returned if found.
#' @param na.rm if TRUE, NA values will be dropped.
#' @param drop if TRUE, the sets with only one unique value will be dropped (not implemented)
#' @param asTibble logical, if the data.frames should be converted into tibbles.
#' @param newNames renaming sets, named character vector or list with new names as values, and old names as names - the input parameter to renameSets function. The operation is performed before merging the data (merge parameter).
#' @param newValues revalue sets, named character vector or list with new values as values, and old values as names - the input parameter to revalueSets function. The operation is performed after merging the data (merge parameter).
#' @param ignore.case grepl parameter if regular expressions are used in '...' or 'name_'.
#' @param stringsAsFactors logical, should the sets values be converted to factors?
#' @param yearsAsFactors logical, should years  be converted to factors? Set 'year' is integer by default.
#' @param scenNameInList logical, should the name of the scenarios be used if not provided in the list with several scenarios?
#' @param verbose 
#'
#' \dontrun{
#' @examples 
#'   data("utopia_scen_BAU.RData")
#'   getData(scen, name = "pDemand", year = 2015, merge = T)
#'   getData(scen, name = "vTechOut", comm = "ELC", merge = T, year = 2015)
#'   elc2050 <- getData(scen, parameters = FALSE, comm = "ELC", year = 2050)
#'   names(elc2050)
#'   elc2050$vBalance
#'}
getData <- function(scen, name = NULL, ..., merge = FALSE, process = FALSE,
                    parameters = TRUE, variables = TRUE, ignore.case = FALSE, 
                    newNames = NULL, newValues = NULL, na.rm = FALSE, drop = FALSE,
                    # addGroups = list(), summarizeGroups = list(),
                    asTibble = TRUE, stringsAsFactors = FALSE, yearsAsFactors = FALSE, 
                    scenNameInList = as.logical(length(scen)-1), verbose = FALSE) {
  
  arg <- list(...)
  argnam <- names(arg)
  stopifnot(!any(duplicated(argnam)))
  if (process) {
    stopifnot(length(newNames) == length(unique(newNames)))
    newNamesDefault = c(tech = "process", stg = "process", 
                 trade = "process", impp = "process",
                 imp = "process", expp = "process", 
                 dem = "process", sup = "process")
    if (!is.null(newNames)) {
      ii <- names(newNamesDefault) %in% names(newNames)
      newNames <- c(newNames, newNamesDefault[!ii])
    } else {
      newNames <- newNamesDefault
    }
    
  }
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
  ii <- grepl("name_", argnam, ignore.case = ignore.case)
  if (any(ii)) {
    if (!is.null(name)) stop("Duplicate parameter 'name' ('name_')")
    name_ <- arg[ii][[1]]
    arg <- arg[!ii]
  } else {
    name_ <- NULL
  }
  ii <- grepl("_$", names(arg), ignore.case = ignore.case)
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
    # if(is.null(scen[[sc]]@modInp@parameters$pDemand@data$comm)) {scen[[sc]] <- .addComm2pDemand(scen[[sc]])}
    for (datype in names(parvar)[parvar]) { # loop over data sources
      if (verbose) cat("Extracting data from", datype, "\n")
      if (length(nflt1) > 0) {sets_names <- paste0("^", nflt1, "$")} else {sets_names <- NULL}
      lt <- findData(scen[[sc]], dataType = datype, setsNames_ = sets_names, ignore.case = ignore.case)
      pvNames <- names(lt)
      # filter for variable/parameter names
      if (!is.null(name)) {
        ii <- pvNames %in% name
        lt <- lt[ii]
      } else if (!is.null(name_)) {
        ii <- sapply(pvNames, function(x) {
          any(sapply(name_, function(y) grepl(y, x, ignore.case = ignore.case)))
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
        ii <- sapply(clNames, function (x) {any(grepl(x, nflt1, ignore.case = ignore.case))})
        clNames <- clNames[ii]
        # browser()
        if (length(clNames) == 0) {
          warning("Inconsistent combination of filters.")
          return(NULL)
        }
        # find pars/vars which have any of the col-names for filtration
        ii <- sapply(lt, function(x) {
          any(sapply(x$names, function(y) {any(grepl(y, clNames, ignore.case = ignore.case))}))
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
                cl_ <- nflt0[grepl(st, nflt_, ignore.case = ignore.case)] # regex match of sets names (find all comm* etc.) for regex match selection
                for (k in cl_) { # loop over sets for regex filtration
                  kk <- kk & grepl(flt_[[paste0(k, "_")]], dat[,k], ignore.case = ignore.case)
                }
                cl <- nflt[grepl(st, nflt, ignore.case = ignore.case)] # regex match of sets names (find all comm* etc.) for exact match selection
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
  # msy <- scen[[1]]@model@sysInfo@milestone$mid
  # if (length(ll) > 0) {
  #   for (i in 1:length(ll)) {
  #     if (!is.null(ll[[i]]$year)) {
  #       ii <- ll[[i]]$year %in% msy # temporary solution
  #       if (!all(ii)) ll[[i]] <- ll[[i]][ii,] # temporary solution
  #     }
  #   }
  # }
  
  # browser()
  
  # Renaming sets
  if (!is.null(newNames)) {
    for (i in 1:length(ll)) {
      ll[[i]] <- renameSets(ll[[i]], newNames)
    }
  }
  
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
          if (is.character(dat[,i])) {dat[,i] <- .crs2fct(dat[,i])}
        }
      } else {
        for (i in 1:length(names(dat))) {
          if (is.factor(dat[,i])) {dat[,i] <- as.character(dat[,i])}
        }
      }
      if (!is.null(dat$year)) {
        if (yearsAsFactors) {
          dat$year <- .crs2fct(dat$year)
        } else {
          dat$year <- .crs2int(dat$year)
        }
      }
      if (asTibble) {dat <- tibble::as_tibble(dat)}
    }
    if (!is.null(newValues)) {
      dat <- revalueSets(dat, newValues)
    }
    return(dat)
  } else {
    if (length(ll) > 0) {
      for (i in 1:length(ll)) {
        if (!is.null(ll[[i]]$year)) {
          if (yearsAsFactors) {
            if (class(ll[[i]]$year) != "factor") ll[[i]]$year <- .crs2fct(ll[[i]]$year)
          } else {
            ll[[i]]$year <- .crs2int(ll[[i]]$year)
          }
        }
        if (stringsAsFactors) {
          colnam <- names(ll[[i]])[sapply(ll[[i]], is.character)]
          for (j in colnam) {
             ll[[i]][,j] <- .crs2fct(ll[[i]][,j])
          }
        } else {
          colnam <- names(ll[[i]])[sapply(ll[[i]], is.factor)]
          for (j in colnam) {
            ll[[i]][,j] <- as.character(ll[[i]][,j])
          }
        }
        if (asTibble) ll[[i]] <- tibble::as_tibble(ll[[i]])
        if (!is.null(newValues)) {
          ll[[i]] <- revalueSets(ll[[i]], newValues)
        }
      }
    }
    return(ll)
  }
}

if (F) {# test
  load("energyRt_tutorial/data/utopia_scen_BAU.RData")
  (dem <- getData(scen, name = "pDemand", year = 2015, merge = T))
  (vTechOut <- getData(scen, name = "vTechOut", comm = "ELC", merge = T, year = 2015))
  # Storage capacity
  getData(scen, name = "vStorageCap", merge = T)
  
}

.crs2int <- function(x) {
  # coerce to integer from factor or character
  if (class(x) == "factor") x <- as.character(x)
  if (class(x) == "character") x <- as.integer(x)
  x
}

.crs2fct <- function(x, levels = NULL, ordered = TRUE) {
  # coerce to integer from factor or character
  if (class(x) == "character") {
    if (!is.null(levels)) {
      x <- factor(x, levels = levels)
    } else {
      x <- as.factor(x)
    }
    if (ordered) x <- as.ordered(x)
  }
  x
}

#' Rename names of data.frame columns of list of data.frames.
#'
#' @param x a data.frame or a list with data frames.
#' @param newNames named character vector or list with new names as values, and old names as names.
#'
#' @return depending on input, the renamed data.frame or the list with renamed data.frames.
#' @export renameSets
#' @examples
#' \dontrun{
#'   x <- data.frame(a = letters, n = 1:length(letters))
#'   x
#'   renameSets(x[1:3,], c(a = "A", n = "N"))
#'   renameSets(x[1:3,], list(a = "B", n = "M"))
#'}
renameSets <- function(x, newNames = NULL) {
  if(any(class(x) == "list")) {
    returnList <- TRUE
  } else {
    returnList <- FALSE
    x <- list(x)
  }
  x <- lapply(x, function(y) {
    nms <- names(y)
    if (is.null(nms)) {
      y
    } else {
      nms <- plyr::revalue(nms, newNames, warn_missing = FALSE)
      names(y) <- nms
      y
    }
  })
  if (returnList) {
    x
  } else {
    x[[1]]
  }
}


#' Replace specified values with new values, in factor or character columns of a data.frame.
#' 
#' @param x vector
#' @param newValues a names list with named vectors. The names of the list should be equal to the names of the data.frame columns in wich values will be replaced. The named vector should have new names as values and old values as names.
#'
#' @return the x data.frame with revalued variables.
#' @export revalueSets
#' @examples
#' \dontrun{
#'   x <- data.frame(a = letters, n = 1:length(letters))
#'   nw1 <- LETTERS[1:10]
#'   names(nw1) <- letters[1:10]
#'   nw2 <- formatC(1:9, width = 3, flag = "0")
#'   names(nw2) <- 1:9
#'   newValues <- list(a = nw1, n = nw2)
#'   newValues
#'   revalueSets(x, newValues)
#'}
revalueSets <- function(x, newValues = NULL) {
  stopifnot(any(class(newValues) == "list"))
  stopifnot(any(class(x) == "data.frame"))
  nnms <- names(newValues)
  xnms <- names(x)
  # browser()
  jj <- xnms %in% nnms
  for (j in xnms[jj]) {
    x[[j]] <- plyr::revalue(x[[j]], newValues[[j]], warn_missing = FALSE)
  }
  x
}

if (F) { # Check
  library(tidyverse)
  # renameSets
  x <- tibble(a = letters, n = as.character(1:length(letters)))
  x
  renameSets(x, c(a = "A", n = "N"))
  
  d <- as.data.frame(x)
  renameSets(d, c(a = "A", n = "N"))
  
  # revalueSets
  nw1 <- LETTERS[1:10]
  names(nw1) <- letters[1:10]
  nw2 <- formatC(1:9, width = 3, flag = "0")
  names(nw2) <- 1:9
  newValues <- list(a = nw1, n = nw2)
  newValues
  revalueSets(x, newValues)
  revalueSets(d, newValues)

}


# .addComm2pDemand <- function(scen) { # temporary
#   dms <- unique(scen@modInp@parameters$pDemand@data$dem)
#   scen@modInp@parameters$pDemand@data$comm <- NA
#   for(demName in dms) {
#     demComm <- scen@model@data$repository@data[[demName]]@commodity
#     ii <- scen@modInp@parameters$pDemand@data$dem == demName
#     scen@modInp@parameters$pDemand@data$comm[ii] <- demComm
#   }
#   sup <- unique(scen@modInp@parameters$sup@data$sup)
#   # browser()
#   scen@modInp@parameters$pSupAva@data$comm <- NA
#   scen@modInp@parameters$pSupCost@data$comm <- NA
#   scen@modInp@parameters$pSupReserve@data$comm <- NA
#   for(supName in sup) {
#     supComm <- scen@model@data$repository@data[[supName]]@commodity
#     ii <- scen@modInp@parameters$pSupAva@data$sup == supName
#     scen@modInp@parameters$pSupAva@data$comm[ii] <- supComm
#     ii <- scen@modInp@parameters$pSupCost@data$sup == supName
#     scen@modInp@parameters$pSupCost@data$comm[ii] <- supComm
#     ii <- scen@modInp@parameters$pSupReserve@data$sup == supName
#     scen@modInp@parameters$pSupReserve@data$comm[ii] <- supComm
#   }
#   
#   return(scen)
# }
# 

 
