#### Deprecated version due to deprecetate simple_data_frame_approximation
simpleInterpolation <- function(frm, parameter, mtp, approxim,
  add_set_name = NULL, add_set_value = NULL) {
  # cat('simple_data_frame_approximation_chk:', parameter, '\n')
  if (approxim$solver == 'GAMS' && nrow(frm) == 0) return(frm)
  dd <- interpolation(frm, parameter,
                    rule       = mtp@interpolation,
                    defVal    = mtp@defVal,
                    year_range = range(approxim$year),
                    approxim   = approxim)
  # Must fixed in the future
  colnames(dd)[[ncol(dd)]] <- 'value'
  for(i in colnames(dd)[-ncol(dd)]) {
      dd[[i]] <- as.character(dd[[i]])
  }
  if (any(colnames(dd) == 'year')) dd[['year']] <- as.numeric(dd[['year']])
  if (is.null(add_set_name)) {
    dd <- dd[, c(mtp@dimSetNames, 'value'), drop = FALSE]
  } else {
    d3 <- data.frame(stringsAsFactors = FALSE)
    for(i in 1:length(add_set_value))
        d3[1:nrow(dd), i] <- rep(add_set_value[i])
    colnames(d3) <- add_set_name
    dd <- cbind(d3, dd[, c(mtp@dimSetNames[-(1:length(d3))], 'value'), drop = FALSE])
  }
  dd[dd$value != mtp@defVal,, drop = FALSE]
}

multiInterpolation <- function(frm, parameter, mtp, approxim,
  add_set_name = NULL, add_set_value = NULL) {
  # if (approxim$solver == 'GAMS' && nrow(frm) == 0) return(frm)
  dd <- interpolation_bound(frm, parameter,
                    defVal    = mtp@defVal,
                    rule       = mtp@interpolation,
                    year_range = range(approxim$year),
                    approxim   = approxim)
  colnames(dd)[[ncol(dd)]] <- 'value'
  for(i in colnames(dd)[-ncol(dd)]) {
      dd[[i]] <- as.character(dd[[i]])
  }
  if (any(colnames(dd) == 'year')) dd[['year']] <- as.numeric(dd[['year']])
  if (is.null(add_set_name)) {
    dd <- dd[, c(mtp@dimSetNames, 'type', 'value'), drop = FALSE]
  } else {
    d3 <- data.frame(stringsAsFactors = FALSE)
    for(i in 1:length(add_set_value))
        d3[1:nrow(dd), i] <- rep(add_set_value[i])
    colnames(d3) <- add_set_name
    dd <- cbind(d3, dd[, c(mtp@dimSetNames[-(1:length(d3))], 'type', 'value'), drop = FALSE])
  }
  dd[(dd$type == 'lo' & dd$value != mtp@defVal[1]) | (dd$type == 'up' & dd$value != mtp@defVal[2]),, drop = FALSE]
}
