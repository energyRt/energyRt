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
      prec <- .add_set_element(prec, obj@data[[i]]@data[[j]], approxim = approxim)
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
        scen@modInp <- .add_set_element(scen@modInp, scen@model@data[[i]]@data[[j]], approxim)
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
.add2_nthreads_1 <- function(n.thread, max.thread, scen, arg, approxim, 
                             interpolation_time_begin, interpolation_count, len_name) {
  # A couple of string for progress bar
  num_classes_for_progrees_bar <- sum(c(sapply(scen@model@data, function(x) length(x@data)), recursive = TRUE))
  # if (num_classes_for_progrees_bar < 50) {
  #   need.tick <- rep(TRUE, num_classes_for_progrees_bar)
  # } else {
  #   need.tick <- rep(FALSE, num_classes_for_progrees_bar)
  #   need.tick[trunc(seq(1, num_classes_for_progrees_bar, length.out = 50))] <- TRUE
  # }
  # Fill DB main data
  tmlg <- 0; mnch <- 0
  cat(rep(' ', len_name), sep = '')
  k <- 0;
  time.log.nm <- rep(NA, num_classes_for_progrees_bar)
  time.log.tm <- rep(NA, num_classes_for_progrees_bar)
  for(i in seq(along = scen@model@data)) {
    for(j in seq(along = scen@model@data[[i]]@data)) { 
      k <- k + 1;
      if (k %% max.thread == n.thread) {
        tmlg <- tmlg + 1
        if (arg$echo) {
          .interpolation_message(scen@model@data[[i]]@data[[j]]@name, k, interpolation_count, 
                                 interpolation_time_begin = interpolation_time_begin, len_name)
        }
        p1 <- proc.time()[3]
        tryCatch({
          scen@modInp <- .add0(scen@modInp, scen@model@data[[i]]@data[[j]], approxim = approxim)
        }, error = function(e) {
          assign('add0_message', list(tracedata = sys.calls(),
            add0_arg = list(obj = scen@modInp, app = scen@model@data[[i]]@data[[j]], approxim = approxim)), 
            globalenv())
          message('\nError in .add0 function, additional info in "add0_message" object\n')
          stop(e)
        })
        time.log.nm[tmlg] <- scen@model@data[[i]]@data[[j]]@name
        time.log.tm[tmlg] <- proc.time()[3] - p1
        # if (need.tick[k] && arg$echo) {
        #   cat('.')
        #   flush.console() 
        # }
      }
    }
  }
  scen@misc$time.log <- data.frame(name = time.log.nm[seq_len(tmlg)], 
                                   time = time.log.tm[seq_len(tmlg)], stringsAsFactors = FALSE)
  # if (arg$echo) cat(' ')
  if (arg$echo)
    .remove_char(len_name)
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
  for (i in seq_along(scen_pr)) 
    scen@misc$time.log <- rbind(scen@misc$time.log, scen_pr[[i]]@misc$time.log)
  
  scen
}

# Implement add0 for all parameters
.get_objects_count <- function(scen) {
  sum(c(sapply(scen@model@data, function(x) length(x@data)), recursive = TRUE))
}
.get_objects_len_name <- function(scen) {
  (25 + max(c(30, max(c(sapply(scen@model@data, function(x) 
    max(sapply(x@data, function(y) nchar(y@name)))), recursive = TRUE)))))
}

.interpolation_message <- function(name, num, interpolation_count, interpolation_time_begin, len_name) {
  jj <- paste0(num, ' (', interpolation_count, '),',
       paste0(rep(' ', max(c(1, 15 - (nchar(name) %% 15)))), collapse = ''),
       name, ', time: ', round(proc.time()[3] - interpolation_time_begin, 2), 's')
  # bug "invalid langth.out element - workaround
  length_out <- len_name - nchar(jj)
   if (length_out < 0) {
     len_name <- len_name + abs(length_out)
     length_out <- 0
   }
  jj <- paste0(jj, paste0(rep(' ', , length_out), collapse = ''))
  cat(rep_len('\b', len_name), jj, sep = '') # , rep(' ', 100), rep('\b', 100)
}

.remove_char <- function(x) {
  if (is.character(x)) x <- nchar(x)
  if (x == 0) return()
  n1 <- paste0(rep('\b', x), collapse = '')
  cat(n1, paste0(rep(' ', x), collapse = ''), n1, sep = '')
  
}


.check_constraint <- function(scen) {
	# Collect sets data
	sets <- list()
	for (ss in c('tech', 'sup', 'dem', 'stg', 'expp', 'imp', 'trade', 
							 'group', 'comm', 'region', 'year', 'slice')) {
		sets[[ss]] <- getParameterData(scen@modInp@parameters[[ss]])[[ss]]
	}
	add_to_err <- function(err_msg, cns, slt, have, psb) {
		if (!all(have %in% psb)) {
			have <- unique(have[!(have %in% psb)])
			tmp <- data.frame(value = have, stringsAsFactors = FALSE)
			tmp$slot <- slt
			tmp$constraint <- cns
			return(rbind(err_msg, tmp[, c('constraint', 'slot', 'value'), drop = FALSE]))			
		}
		return(err_msg)
	}
	sets$lag.year <- sets$year
	sets$lead.year <- sets$year
	err_msg <- NULL
	# Check sets in constraints
	for (i in seq_along(scen@model@data)) {
		for (j in seq_along(scen@model@data[[i]]@data)[sapply(scen@model@data[[i]]@data, class) == 'constraint']) {
			tmp <- scen@model@data[[i]]@data[[j]]
			for (k in colnames(tmp@rhs)) if (k != 'value' && k != 'year') {
				err_msg <- add_to_err(err_msg, cns = tmp@name, slt = 'rhs', have = tmp@for.each[[k]], psb = sets[[k]])
			}
			for (u in seq_along(tmp@lhs)) {
				for (k in colnames(tmp@lhs[[u]]@mult)) if (k != 'value' && k != 'year') {
					err_msg <- add_to_err(err_msg, cns = tmp@name, slt = paste0('lhs (', u, ') mult'), have = tmp@lhs[[u]]@mult[[k]], psb = sets[[k]])
				}
				for (k in names(tmp@lhs[[u]]@for.sum)) if (k != 'value' && k != 'year' && !all(is.na(tmp@lhs[[u]]@for.sum[[k]]))) {
					err_msg <- add_to_err(err_msg, cns = tmp@name, slt = paste0('lhs (', u, ') for.sum'), have = tmp@lhs[[u]]@for.sum[[k]], psb = sets[[k]])
				}
			}
		}
	}
	if (!is.null(err_msg)) {
		nn <- capture.output(err_msg)
		stop(paste0('There unknow sets in constrint(s)\n', paste0(nn, collapse = '\n')))
	}
}



.check_weather <- function(scen) {
	weather <- scen@modInp@parameters$weather@data$weather
	err_msg <- list()
	pars <- names(scen@modInp@parameters)[sapply(scen@modInp@parameters, function(x) !is.null(x@data$weather) && 
																					nrow(x@data) != 0)]
	for (pr in pars) {
		tmp <- scen@modInp@parameters[[pr]]@data
		tmp <- tmp[!is.na(tmp$weather) & !(tmp$weather %in% weather),, drop = FALSE]
		if (nrow(tmp) != 0) err_msg[[pr]] <- tmp
	}
	if (length(err_msg) != 0) {
		nn <- capture.output(err_msg)
		stop(paste0('There unknow weather in parameters\n', paste0(nn, collapse = '\n')))
	}
}
