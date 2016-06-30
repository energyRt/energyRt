#### Deprecated version due to deprecetate simple_data_frame_approximation
#simple_data_frame_approximation_chk <- function(frm, parameter, mtp, approxim,
#  add_set_name = NULL, add_set_value = NULL) {
#  d1 <- data.frame(d = mtp@interpolation, stringsAsFactors = FALSE)
#  colnames(d1) <- parameter
#  d2 <- data.frame(d = mtp@default)
#  colnames(d2) <- parameter
#  dd <- as.data.frame.table(simple_data_frame_approximation(frm, parameter,
#                    interpolation = d1,
#                    default_value = d2,
#                    year_range    = range(approxim$year),
#                    suppress_warning_region = FALSE,
#                    return_array = TRUE,
#                    lev_approx = list_to_lev_approx(approxim)))
#  for(i in colnames(dd)[-ncol(dd)]) {
#      dd[[i]] <- as.character(dd[[i]])
#  }
#  if (any(colnames(dd) == 'year')) dd[['year']] <- as.numeric(dd[['year']])
#  if (is.null(add_set_name)) {
#    dd[, c(mtp@set, 'Freq'), drop = FALSE]
#  } else {
#    d3 <- data.frame(stringsAsFactors = FALSE)
#    for(i in 1:length(add_set_value))
#        d3[1:nrow(dd), i] <- rep(add_set_value[i])
#    colnames(d3) <- add_set_name
#    dd <- cbind(d3, dd[, c(mtp@set[-(1:length(d3))], 'Freq'), drop = FALSE])
#    dd
#  }
#}
## undebug(simple_data_frame_approximation_chk)
simple_data_frame_approximation_chk <- function(frm, parameter, mtp, approxim,
  add_set_name = NULL, add_set_value = NULL) {
  # cat('simple_data_frame_approximation_chk:', parameter, '\n')
  dd <- interpolation(frm, parameter,
                    rule       = mtp@interpolation,
                    default    = mtp@default,
                    year_range = range(approxim$year),
                    approxim   = approxim)
  #cat(parameter, '\n')
  # Must fixed in the future
  colnames(dd)[[ncol(dd)]] <- 'Freq'
  for(i in colnames(dd)[-ncol(dd)]) {
      dd[[i]] <- as.character(dd[[i]])
  }
  if (any(colnames(dd) == 'year')) dd[['year']] <- as.numeric(dd[['year']])
  if (is.null(add_set_name)) {
    dd[, c(mtp@set, 'Freq'), drop = FALSE]
  } else {
    d3 <- data.frame(stringsAsFactors = FALSE)
    for(i in 1:length(add_set_value))
        d3[1:nrow(dd), i] <- rep(add_set_value[i])
    colnames(d3) <- add_set_name
    dd <- cbind(d3, dd[, c(mtp@set[-(1:length(d3))], 'Freq'), drop = FALSE])
    dd
  }
}

#### Deprecated version due to deprecetate data_frame_approximation
#data_frame_approximation_chk <- function(frm, parameter, mtp, approxim,
#  add_set_name = NULL, add_set_value = NULL) {
#  # cat('data_frame_approximation_chk:', parameter, '\n')
#  d1 <- as.data.frame(array(mtp@interpolation, dim = c(1, 2),
#      dimnames = list(1, paste(parameter, c('.lo', '.up'), sep = ''))),
#        stringsAsFactors = FALSE)
#  d2 <- as.data.frame(array(mtp@default, dim = c(1, 2),
#      dimnames = list(1, paste(parameter, c('.lo', '.up'), sep = ''))),
#        stringsAsFactors = FALSE)
#  dd <- as.data.frame.table(data_frame_approximation(frm, parameter,
#                    interpolation = d1,
#                    default_value = d2,
#                    year_range    = range(approxim$year),
#                    suppress_warning_region = FALSE,
#                    return_array = TRUE,
#                    lev_approx = list_to_lev_approx(approxim)))
#  for(i in colnames(dd)[-ncol(dd)]) {
#      dd[[i]] <- as.character(dd[[i]])
#  }
#  if (any(colnames(dd) == 'year')) dd[['year']] <- as.numeric(dd[['year']])
#  if (is.null(add_set_name)) {
#    dd[, c(mtp@set, 'type', 'Freq'), drop = FALSE]
#  } else {
#    d3 <- data.frame(stringsAsFactors = FALSE)
#    for(i in 1:length(add_set_value))
#        d3[1:nrow(dd), i] <- rep(add_set_value[i])
#    colnames(d3) <- add_set_name
#    dd <- cbind(d3, dd[, c(mtp@set[-(1:length(d3))], 'type', 'Freq'), drop = FALSE])
#    dd
#  }
#}

data_frame_approximation_chk <- function(frm, parameter, mtp, approxim,
  add_set_name = NULL, add_set_value = NULL) {
  dd <- interpolation_bound(frm, parameter,
                    default    = mtp@default,
                    rule       = mtp@interpolation,
                    year_range = range(approxim$year),
                    approxim   = approxim)
  colnames(dd)[[ncol(dd)]] <- 'Freq'
  for(i in colnames(dd)[-ncol(dd)]) {
      dd[[i]] <- as.character(dd[[i]])
  }
  if (any(colnames(dd) == 'year')) dd[['year']] <- as.numeric(dd[['year']])
  if (is.null(add_set_name)) {
    dd[, c(mtp@set, 'type', 'Freq'), drop = FALSE]
  } else {
    d3 <- data.frame(stringsAsFactors = FALSE)
    for(i in 1:length(add_set_value))
        d3[1:nrow(dd), i] <- rep(add_set_value[i])
    colnames(d3) <- add_set_name
    dd <- cbind(d3, dd[, c(mtp@set[-(1:length(d3))], 'type', 'Freq'), drop = FALSE])
    dd
  }
}
