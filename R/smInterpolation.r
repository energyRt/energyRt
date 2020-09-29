#### Deprecated version due to deprecetate simple_data_frame_approximation
simpleInterpolation <- function(frm, parameter, mtp, approxim,
  add_set_name = NULL, add_set_value = NULL, remove_duplicate = NULL, removeDefault = TRUE, 
  remValue = NULL, all.val = FALSE) {

  there.is.year <- any(colnames(frm) == 'year')
  if (approxim$fullsets && mtp@defVal != 0 && mtp@defVal != Inf) all.val <- TRUE
  if (!all.val && nrow(frm) == 0) return(NULL)
  
  if (!is.null(mtp@misc$not_need_interpolate)) {
    # approxim <- approxim[!(names(approxim) %in% mtp@misc$not_need_interpolate)]
    frm <- frm[, !(colnames(frm) %in% mtp@misc$not_need_interpolate), drop = FALSE]
    if (any(mtp@misc$not_need_interpolate == 'year')) there.is.year <- FALSE
    fl <- add_set_name %in% mtp@misc$not_need_interpolate
    if (any(fl)) {
      add_set_name <- add_set_name[!fl]
      add_set_value <- add_set_value[!fl]
    }
    frm <- frm[!duplicated(frm),, drop = FALSE]
  }

  dd <- interpolation(frm, parameter,
                    rule       = mtp@interpolation,
                    defVal    = mtp@defVal,
                    year_range = range(approxim$year),
                    approxim   = approxim, all = all.val)

  if (is.null(dd)) return(NULL)
  if (!all.val) {
    dd <- dd[dd[[ncol(dd)]] != 0,, drop = FALSE]
    if (nrow(dd) == 0) return(NULL)
  }
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
    stnd <- stnd[!(stnd %in% mtp@misc$not_need_interpolate)]
    if (any(ls(globalenv()) == 'KKK')) browser()
    dd <- cbind(d3, dd[, c(stnd, 'value'), drop = FALSE])
  }
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
  if (nrow(dd) == 0) return(NULL)
  
  dd
}

multiInterpolation <- function(frm, parameter, mtp, approxim,
  add_set_name = NULL, add_set_value = NULL, remove_duplicate = NULL, 
  remValueUp = NULL, remValueLo = NULL) {
  there.is.year <- any(colnames(frm) == 'year')
  if (!is.null(mtp@misc$not_need_interpolate)) {
    frm <- frm[, !(colnames(frm) %in% mtp@misc$not_need_interpolate), drop = FALSE]
    if (any(mtp@misc$not_need_interpolate == 'year')) there.is.year <- FALSE
    fl <- add_set_name %in% mtp@misc$not_need_interpolate
    if (any(fl)) {
      add_set_name <- add_set_name[!fl]
      add_set_value <- add_set_value[!fl]
    }
    frm <- frm[!duplicated(frm),, drop = FALSE]
  }
  
  dd <- interpolation_bound(frm, parameter,
                    defVal    = mtp@defVal,
                    rule       = mtp@interpolation,
                    year_range = range(approxim$year),
                    approxim   = approxim)
  if (is.null(dd)) return(NULL)
  dd <- dd[dd[[ncol(dd)]] != 0,, drop = FALSE]
  if (nrow(dd) == 0) return(NULL)
  
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
    stnd <- stnd[!(stnd %in% mtp@misc$not_need_interpolate)]

    dd <- cbind(d3, dd[, c(stnd, 'type', 'value'), drop = FALSE])
  }
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
  if (nrow(dd) == 0) return(NULL)
  dd
}
