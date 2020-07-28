downsize <- function(scen) {
	for (pr in grep('^p', names(scen@modInp@parameters), value = TRUE)) {
		if ((scen@modInp@parameters[[pr]]@nValues == -1 && nrow(scen@modInp@parameters[[pr]]@data) > 0) ||
				scen@modInp@parameters[[pr]]@nValues > 0) {
			if (scen@modInp@parameters[[pr]]@nValues != -1)
				scen@modInp@parameters[[pr]]@data <- scen@modInp@parameters[[pr]]@data[1:scen@modInp@parameters[[pr]]@nValues,, drop = FALSE]
			tmp <- scen@modInp@parameters[[pr]]@data
			tmp <- tmp[order(tmp$value), ]
			if (all(tmp$value == tmp$value[1])) { # only one possible value
				if (!is.null(tmp$type)) {
					tmp <- tmp[!duplicated(tmp$type), 'value', drop = FALSE]
				} else tmp <- tmp[1, 'value', drop = FALSE]
			} else {
				# remove col with single value 
				unv <- sapply(tmp, function(x) length(unique(x)))
				tmp <- tmp[, unv != 1 | names(unv) %in% c('type', 'value')]
				unv <- unv[unv != 1] 
				# remove other 
				cand <- colnames(tmp)[!(colnames(tmp) %in% c('type', 'value')) & nrow(tmp) / unv >= unv['value']]
				for (cc in cand) {
					if (all(aggregate(tmp$value, tmp[, !(colnames(tmp) %in% c(cc, 'value')), drop = FALSE], function(x) all(x == x[1]))$x)) {
						tmp <- tmp[!duplicated(tmp[, !(colnames(tmp) %in% c(cc, 'value')), drop = FALSE]), colnames(tmp) != cc, drop = FALSE]
					}
				}
			}
			if (ncol(scen@modInp@parameters[[pr]]@data) != ncol(tmp)) {
				rem_col <- seq_len(ncol(scen@modInp@parameters[[pr]]@data))[!(colnames(scen@modInp@parameters[[pr]]@data) %in% colnames(tmp))]
				scen@modInp@parameters[[pr]]@misc$rem_col <- rem_col
				scen@modInp@parameters[[pr]]@data <- tmp
				if (scen@modInp@parameters[[pr]]@nValues != -1) scen@modInp@parameters[[pr]]@nValues <- nrow(tmp)
				scen@modInp@parameters[[pr]]@dimSetNames <- scen@modInp@parameters[[pr]]@dimSetNames[-rem_col]
			}
		}
	}
	scen
}


.find_null_column <- function(scen) {
	# Collect all class names
	# scn_class <- unique(c(sapply(scen@model@data, function(x) unique(sapply(x@data, class))), recursive = TRUE))
	scn_class <- c('supply', 'demand', 'export', 'import', 'trade', 'technology', 'tax', 'subs')
	rs <- NULL
	# Handle with class 
	for(cls in scn_class) {
		dtf <- getSlots(cls)[getSlots(cls) == 'data.frame']
		tmp <- new(cls)
		# Handle with class/slot
		for (jj in names(dtf)) {
				## Check if
				i <- 1
				fl <- colnames(slot(tmp, jj))[!sapply(slot(tmp, jj), is.numeric) | colnames(slot(tmp, jj)) == 'year']
				while (length(fl) != 0 && i <= length(scen@model@data)) {
					j <- 1
					while (length(fl) != 0 && j <= length(scen@model@data[[i]]@data)) {
						if (class(scen@model@data[[i]]@data) == cls) {
							#fl <- fl[apply(is.na(slot(scen@model@data[[i]]@data, jj)[, fl, drop = FALSE]), 2, all)]
						}
						j <- j + 1
					}
					i <- i + 1
				}
				if (length(fl) != 0)
					rs <- rbind(rs, data.frame(class = rep(cls, length(fl)), slot = rep(jj, length(fl)), col = fl))
		}
	}
	rs	
}
