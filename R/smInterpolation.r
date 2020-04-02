#### Deprecated version due to deprecetate simple_data_frame_approximation
simpleInterpolation <- function(frm, parameter, mtp, approxim,
  add_set_name = NULL, add_set_value = NULL, remove_duplicate = NULL, removeDefault = TRUE, remValue = NULL) {
  there.is.year <- any(colnames(frm) == 'year')
  if (nrow(frm) == 0) return(frm)
  dd <- interpolation(frm, parameter,
                    rule       = mtp@interpolation,
                    defVal    = mtp@defVal,
                    year_range = range(approxim$year),
                    approxim   = approxim)
  if (is.null(dd)) return(NULL)
  # Must fixed in the future
  colnames(dd)[[ncol(dd)]] <- 'value'
  for(i in colnames(dd)[-ncol(dd)]) {
      dd[[i]] <- as.character(dd[[i]])
  }
  if (there.is.year) dd[['year']] <- as.numeric(dd[['year']])
  if (is.null(add_set_name)) {
    dd <- dd[, c(mtp@dimSetNames, 'value'), drop = FALSE]
  } else {
    d3 <- data.frame(stringsAsFactors = FALSE)
    for(i in 1:length(add_set_value))
        d3[1:nrow(dd), i] <- rep(add_set_value[i])
    colnames(d3) <- add_set_name
    stnd <- mtp@dimSetNames[-(1:length(d3))]
    # It was added for trading routes
    if (sum(stnd %in% c('src', 'dst')) == 2) {
    	stnd <- c(stnd[stnd != 'src' & stnd != 'dst'], 'region')
    } 
    dd <- cbind(d3, dd[, c(stnd, 'value'), drop = FALSE])
  }
  # For increase speed
  # if (removeDefault)
  # 	dd <- dd[dd$value != mtp@defVal,, drop = FALSE]
  if (!is.null(remove_duplicate) && nrow(dd) != 0) {
    fl <- rep(TRUE, nrow(dd))
    for (i in seq_along(remove_duplicate)) {
      fl <- (fl & dd[, remove_duplicate[[i]][1]] != dd[, remove_duplicate[[i]][2]])
    }
    dd <- dd[fl,, drop = FALSE]
  }
  if (there.is.year && !is.null(approxim$mileStoneYears)) {
    dd <- dd[dd$year %in% approxim$mileStoneYears,, drop = FALSE]
  }
  if (!is.null(remValue))
    dd <- dd[!(dd$value %in% remValue), ]
  dd
}

multiInterpolation <- function(frm, parameter, mtp, approxim,
  add_set_name = NULL, add_set_value = NULL, remove_duplicate = NULL, 
  remValueUp = NULL, remValueLo = NULL) {
  there.is.year <- any(colnames(frm) == 'year')
  dd <- interpolation_bound(frm, parameter,
                    defVal    = mtp@defVal,
                    rule       = mtp@interpolation,
                    year_range = range(approxim$year),
                    approxim   = approxim)
  if (is.null(dd)) return(NULL)
  colnames(dd)[[ncol(dd)]] <- 'value'
  for(i in colnames(dd)[-ncol(dd)]) {
      dd[[i]] <- as.character(dd[[i]])
  }
  if (there.is.year) dd[['year']] <- as.numeric(dd[['year']])
  if (is.null(add_set_name)) {
    dd <- dd[, c(mtp@dimSetNames, 'type', 'value'), drop = FALSE]
  } else {
    d3 <- data.frame(stringsAsFactors = FALSE)
    for(i in 1:length(add_set_value))
        d3[1:nrow(dd), i] <- rep(add_set_value[i])
    colnames(d3) <- add_set_name
    stnd <- mtp@dimSetNames[-(1:length(d3))]
    # It was added for trading routes
    if (sum(stnd %in% c('src', 'dst')) == 2) {
      stnd <- c(stnd[stnd != 'src' & stnd != 'dst'], 'region')
    } 
    
    dd <- cbind(d3, dd[, c(stnd, 'type', 'value'), drop = FALSE])
  }
  # For increase speed, not work for GLPK
  # dd <- dd[(dd$type == 'lo' & dd$value != mtp@defVal[1]) | (dd$type == 'up' & dd$value != mtp@defVal[2]),, drop = FALSE]
  dd <- dd[(dd$type == 'lo') | (dd$type == 'up'),, drop = FALSE]
  if (!is.null(remove_duplicate) && nrow(dd) != 0) {
    fl <- rep(TRUE, nrow(dd))
    for (i in seq_along(remove_duplicate)) {
      fl <- (fl & dd[, remove_duplicate[[i]][1]] != dd[, remove_duplicate[[i]][2]])
    }
    dd <- dd[fl,, drop = FALSE]
  }
  if (there.is.year && !is.null(approxim$mileStoneYears)) {
    dd <- dd[dd$year %in% approxim$mileStoneYears,, drop = FALSE]
  }
  if (!is.null(remValueUp))
    dd <- dd[!(dd$value %in% remValueUp & dd$type == 'up'), ]
  if (!is.null(remValueLo))
    dd <- dd[!(dd$value %in% remValueLo & dd$type == 'lo'), ]
  dd
}
