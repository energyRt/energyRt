# Read default parameter from sysInfo
.read_default_data <- function(prec, ss) {
  for(i in seq(along = prec@parameters)) {
    # assign('test', prec@parameters[[i]], globalenv())
    if (any(prec@parameters[[i]]@colName != '')) {
      prec@parameters[[i]]@defVal <-
        as.numeric(ss@defVal[1, prec@parameters[[i]]@colName])
      prec@parameters[[i]]@interpolation <-
        as.character(ss@interpolation[1, prec@parameters[[i]]@colName])
    }
  }
  prec
}

.add_repository <- function(mdl, x) {
  if (class(x) == 'list') {
    for (i in seq_along(x)) {
      mdl <- .add.repository(mdl, x[[i]])
    }
  } else {
    mdl <- add(mdl, x)
  }
  mdl
}

.add_discount_approxim <- function(scen, approxim) {
	approxim$discountFactor <- energyRt:::.getTotalParameterData(scen@modInp, 'pDiscountFactor', FALSE)
	approxim$discount <- energyRt:::.getTotalParameterData(scen@modInp, 'pDiscount', FALSE)
	yy <- approxim$discountFactor
	# ll <- NULL
	# for (rg in unique(yy$region)) {
	# 	l1 <- yy[yy$region == rg, ]
	# 	l1$value <- cumsum(l1$value)
	# 	if (is.null(ll)) ll <- l1 else ll <- rbind(ll, l1)
	# }
	# approxim$discountCum <- ll
	approxim
}
# Get commodity slice map for interpolate
.get_map_commodity_slice_map <- function(obj) {
  xx <- list()
  for(i in seq(along = obj@data)) {
    for(j in seq(along = obj@data[[i]]@data)) { #
      prec <- add_name(prec, obj@data[[i]]@data[[j]], approxim = approxim)
      if (class(obj@data[[i]]@data[[j]]) == 'commodity') {
        if (length(obj@data[[i]]@data[[j]]@slice) == 0) 
          obj@data[[i]]@data[[j]]@slice <- approxim$slice@default_slice_level
        commodity_slice_map[[obj@data[[i]]@data[[j]]@name]] <- obj@data[[i]]@data[[j]]@slice
      }
    }
  }
}
# Apply func to data in scenario by class and return scenario
.apply_to_code_ret_scen <- function(scen, func, ..., clss = NULL) {
  for(i in seq(along = scen@model@data)) {
    for(j in seq(along = scen@model@data[[i]]@data)) {
      if (is.null(clss) || any(class(scen@model@data[[i]]@data[[j]]) == clss)) {
        scen@model@data[[i]]@data[[j]] <- func(scen@model@data[[i]]@data[[j]], ...)
      }
    }
  }
  scen
}

# Apply func to data in scenario by class and return list
.apply_to_code_ret_list <- function(scen, func, ..., clss = NULL, need.name = TRUE) {
  rs <- list()
  for(i in seq(along = scen@model@data)) {
    for(j in seq(along = scen@model@data[[i]]@data)) {
      if (is.null(clss) || any(class(scen@model@data[[i]]@data[[j]]) == clss)) {
        if (need.name) {
          rr <- func(scen@model@data[[i]]@data[[j]], ...)
          rs[[rr$name]] <- rr$val
        } else {
          rs[[length(rs) + 1]] <- func(scen@model@data[[i]]@data[[j]], ...)
        }
      }
    }
  }
  rs
}

# Fill slice level for commodity if not defined
.fill_default_slice_leve4comm <- function(scen, def.level) {
  .apply_to_code_ret_scen(scen = scen, clss = 'commodity', def.level,
      func = function(x, def.level) {
        if (length(x@slice) == 0) x@slice <- def.level
        x
  })
}

# Add name for basic set
.add_name_for_basic_set <- function(scen, approxim) {
  for(i in seq(along = scen@model@data)) {
    for(j in seq(along = scen@model@data[[i]]@data)) {
        scen@modInp <- add_name(scen@modInp, scen@model@data[[i]]@data[[j]], approxim)
    }
  }
  scen
}

.remove_early_retirment <- function(scen) {
  scen <- .apply_to_code_ret_scen(scen = scen, clss = 'technology', 
                                  func = function(x) {
                                    x@early.retirement <- FALSE
                                    x})
  scen
}

# Add commodity slice_level map to approxim
.get_map_commodity_slice_map <- function(scen) {
  .apply_to_code_ret_list(scen = scen, clss = 'commodity', func = function(x) {
      list(name = x@name, val = x@slice)
    })
}


# Implement add0 for all parameters
.add2_nthreads_1 <- function(n.thread, max.thread, scen, arg, approxim) {
  # A couple of string for progress bar
  num_classes_for_progrees_bar <- sum(c(sapply(scen@model@data, function(x) length(x@data)), recursive = TRUE))
  if (num_classes_for_progrees_bar < 50) {
    need.tick <- rep(TRUE, num_classes_for_progrees_bar)
  } else {
    need.tick <- rep(FALSE, num_classes_for_progrees_bar)
    need.tick[trunc(seq(1, num_classes_for_progrees_bar, length.out = 50))] <- TRUE
  }
  # Fill DB main data
  k <- 0
  for(i in seq(along = scen@model@data)) {
    for(j in seq(along = scen@model@data[[i]]@data)) { 
      k <- k + 1
      if (k %% max.thread == n.thread) {
        tryCatch({
          scen@modInp <- .add0(scen@modInp, scen@model@data[[i]]@data[[j]], approxim = approxim)
        }, error = function(e) {
          assign('add0_message', list(tracedata = sys.calls(),
            add0_arg = list(obj = scen@modInp, app = scen@model@data[[i]]@data[[j]], approxim = approxim)), 
            globalenv())
          message('\nThere are error during work .add0. More information in "add0_message"\n')
          stop(e)
        })
        if (need.tick[k] && arg$echo) {
          cat('.')
          flush.console() 
        }
      }
    }
  }
  if (arg$echo) cat(' ')
  scen
}
.merge_scen <- function(scen_pr, use_par) {
  if (scen_pr[[1]]@modInp@parameters$mCommSlice@nValues == -1)
    stop('have to do')
  scen <- scen_pr[[1]]
  scen_pr <- scen_pr[-1]
  for (nm in use_par) {
    hh <- sapply(scen_pr, function(x) x@modInp@parameters[[nm]]@nValues)
    if (sum(hh) != 0)
      scen@modInp@parameters[[nm]]@data[scen@modInp@parameters[[nm]]@nValues + sum(hh), ] <- NA
    for (i in seq_along(hh)[hh != 0])  {
      scen@modInp@parameters[[nm]]@data[scen@modInp@parameters[[nm]]@nValues + 1:hh[i], ] <- 
        scen_pr[[i]]@modInp@parameters[[nm]]@data[1:hh[i], ]
      scen@modInp@parameters[[nm]]@nValues <- scen@modInp@parameters[[nm]]@nValues + hh[i]
    }
    
  }
  scen
}


