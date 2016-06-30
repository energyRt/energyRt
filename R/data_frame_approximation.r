# Approximation data.frame
# return array:
#   if is_simple with dim = c(add_col, year)
#   if !is_simple with dim = (add_col, year, c('LO', 'UP'))
#data_frame_approximation <- function(frm, parameter, add_col,
#          rule = 'back.intra.force', default, is_simple = TRUE) {
#  if (!is_simple) {
#    stop('Need finish')
#  } else simple_data_frame_approximation(frm, parameter, add_col, rule, default)
#}

#########################################################################################################
# Approximation data.frame, but only simple vesrion
#   return array dim = (year, add_col, value)
#   add_col: r region
#   add_col: y year    er. 1: with same r & same or NA s: any(is.na(y)) & any(!is.na(y))
#   add_col: s slice  er. 2: with same r & same or NA y: any(is.na(s)) & any(!is.na(s))
#########################################################################################################
list_to_lev_approx <- function(x) {
  dd <- data.frame(stringsAsFactors = FALSE)
  for(i in names(x)) dd[, i] <- factor(levels = x[[i]])
  dd
}
# Slice work incorrect

simple_data_frame_approximation <- function(frm, parameter, interpolation, 
                            default_value, year_range, suppress_warning_region = FALSE,
                            return_array = TRUE, lev_approx = NULL#,
                            #get_only_lev_approx = FALSE
                            ) {   
  year_range <- sort(year_range)
  # Check
  if (!is.data.frame(frm)) stop('Frame is not data frame')
  if (all(parameter != colnames(frm))) stop('There is no column')
  frm <- frm[!is.na(frm[, parameter]), , drop = FALSE]
  for_test <- c('year', 'region', 'slice', 'group', 'comm')
  lvl <- for_test[
      sapply(for_test, function(x) any(x == colnames(frm)))
  ]
  lv2 <- for_test[
      sapply(for_test, function(x) any(x == colnames(frm)))
  ]
  check_lev <- function(frm, lvl) {
    if (length(lvl) > 1) {
      all(sapply(unique(frm[, lvl[1]]), function(x) {
          fl <- is.na(frm[, lvl[1]])
          if (!is.na(x)) fl <- fl | frm[, lvl[1]] == x
          check_lev(frm[fl, , drop = FALSE], lvl[-1])
      }))
    } else (all(is.na(frm[, lvl])) | all(!is.na(frm[, lvl])))
  }
  if (!check_lev(frm, lvl) || !check_lev(frm, lv2)) stop('There is conflict between ', paste(lvl, collapse = ' and '))
  if (!is.null(lev_approx) && !is.data.frame(lev_approx)) stop('lev_approx must be data.frame')   
  if (!is.null(lev_approx)) {
    for(i in for_test[-1])
      if (any(i == colnames(frm))) {
        if (any(i == colnames(lev_approx)) && !is.factor(lev_approx[, i])) 
            stop(paste('column', i, 'isn\'t factor in lev_approx'))
        if (any(i == colnames(lev_approx))) 
              frm[, i] <- factor(as.character(frm[, i]), 
                    levels = sort(unique(c(as.character(frm[, i]), 
                                          levels(frm[, i]), 
                                          levels(lev_approx[, i])))))
            else frm[, i] <- as.factor(frm[, i])
      }
  } else {
    for(i in for_test[-1])
      if (any(i == colnames(frm)) && !is.factor(frm[, i])) frm[, i] <- as.factor(frm[, i])
  }
  for(i in for_test[-1])
    if (any(i == colnames(frm)) && !is.factor(frm[, i])) stop('Warning column')
  for(i in for_test[-1])
     if (any(i == colnames(frm)) && nlevels(frm[, i]) == 0) {
      if (nrow(frm) > 0) frm[, i] <- factor(rep('-', nrow(frm)), levels = '-') else
                          frm[, i] <- factor(NULL, levels = '-') 
     }
  #if (any('region' == colnames(frm)) && any(is.na(frm$region)) && any(!is.na(frm$region))) {
  #  if (!suppress_warning_region) warning('There are undefined and defined region')
  #}
  #if (any('slice' == colnames(frm)) && !is.factor(frm$slice)) stop('slice isn\'t factor')
  # Rest check for default and rule approximation
  #if (return_array) {
  # Result
  ndim <- c()
  dimnm <- list()
  clmn <- c()
  for(i in for_test[-1]) {
    if (any(colnames(frm) == i)) {
      ndim <- c(ndim, nlevels(frm[, i]))
      dimnm[[length(ndim)]] <- levels(frm[, i])
      clmn <- c(clmn, i)
    }
  }
  f_year <- any(colnames(frm) == 'year')
  if (f_year) {
    ndim <- c(ndim, (max(c(frm$year, year_range), na.rm = TRUE)
                    - min(c(frm$year, year_range), na.rm = TRUE)
                    + 1))
    dimnm[[length(ndim)]] <- (min(c(frm$year, year_range), na.rm = TRUE):
                              max(c(frm$year, year_range), na.rm = TRUE))
    clmn <- c(clmn, 'year')
    frm$year <- factor(frm$year, levels = dimnm[[length(ndim)]])
  }
  names(ndim) <- clmn   
  names(dimnm) <- clmn   
  # Create array with known parameter
  rs <- array(NA, dim = ndim, dimnames = dimnm)
  if (nrow(frm) > 0) {
    # Sort frm for NA was after NOT NA
    gg <- rep(0, nrow(frm))
    mm <- lapply(1:nrow(frm), function(x) 0)
    for(i in clmn) {
      hh <- as.numeric(frm[, i])
      hh[is.na(hh)] <- 0
      gg <- gg * (nlevels(frm[, i]) + 1) + hh - 1
    }
    mm <- lapply(1:nrow(frm), function(x) 1)
    for(i in rev(clmn)) {
      hh <- as.numeric(frm[, i])
      mm <- lapply(1:length(mm), function(x) {
        if (is.na(hh[x])) {
          1:nlevels(frm[, i]) + (mm[[x]] - 1) * nlevels(frm[, i])
        } else {
          (mm[[x]] - 1) * nlevels(frm[, i]) + hh[x]
        } 
      })
    }
    fl <- sort(gg, index.return = TRUE, decreasing = !TRUE)$ix
    frm <- frm[fl, ]
    mm  <- mm[fl]      
    if (anyDuplicated(gg) != 0) {
      stop('Two or more value define for exactly the same time period')
    }
    # Insert data to array rs
    for(i in 1:length(mm)) rs[mm[[i]]] <- frm[i, parameter]
  }
  # Approximate two points
  appoximation <- function(x, int, def) {
    if (all(!is.na(x))) return(x);
    if (is.na(x[1]) && any(grep('back', int))) {
      if (any(!is.na(x))) {
        ii <- min((1:length(x))[!is.na(x)]) 
        x[1:ii] <- x[ii]
      } else {
        if (is.null(def)) stop('There is no default approximation')
        x[] <- def
      }  
    }
    if (is.na(x[length(x)]) && any(grep('forth', int))) {
      if (any(!is.na(x))) {
        ii <- max((1:length(x))[!is.na(x)]) 
        x[ii:length(x)] <- x[ii]
      } else {
        if (is.null(def)) stop('There is no default approximation')
        x[] <- def
      }  
    }
    if (any(is.na(x)) && any(grep('inter', int))) {
      if (any(!is.na(x))) {
        i_min <- (2:length(x) - 1)[is.na(x[-1])  & !is.na(x[-length(x)])]
        i_max <- (2:length(x))[!is.na(x[-1]) & is.na(x[-length(x)])]
        stopifnot(length(i_min) == length(i_max))
        for(i in 1:length(i_min)) {
          x[i_min[i]:i_max[i]] <- 
              seq(x[i_min[i]], x[i_max[i]], length.out = i_max[i] - i_min[i] + 1)
        }
      } else {
        if (is.null(def)) stop('There is no default approximation')
        x[is.na(x)] <- def
      }  
    }
    x
  }
  if (f_year) {
    mz <- matrix(1:prod(ndim[clmn != 'year']), 
          prod(ndim[clmn != 'year']), dim(rs)[clmn == 'year']) +
         prod(ndim[clmn != 'year']) * matrix(1:dim(rs)[clmn == 'year'] - 1, 
            prod(ndim[clmn != 'year']), dim(rs)[clmn == 'year'], byrow = TRUE)
  } else {
    mz <- matrix(1:prod(ndim), prod(ndim), 1)
  }   
  if (any(is.na(rs))) {
    int <- NULL
    if (nrow(interpolation) == 1 && !is.na(interpolation[, parameter])) 
        int <- interpolation[, parameter]
    if (is.null(int)) stop('Interpolation value isn\'t define')
    def <- NULL
    if (nrow(default_value) == 1 && !is.na(default_value[, parameter])) 
        def <- as.numeric(default_value[, parameter])
    if (is.null(def)) stop('Default value isn\'t define')
    if (all(int != c('', 'back', 'back.inter', 'back.forth',
            'back.inter.forth', 'inter', 'inter.forth', 'forth'))) {
                stop('Unknown approximation, use without')
    }  
    for(i in 1:nrow(mz))
          rs[mz[i, ]] <- appoximation(rs[mz[i, ]], int, def)
  }
  rgg <- as.numeric(dimnm$year)
  if (f_year && any(range(year_range) != range(rgg))) {
    rs <- array(rs[(prod(ndim[-length(ndim)]) * sum(rgg < year_range[1]) + 1):
                    (prod(ndim[-length(ndim)]) * sum(rgg <= year_range[2]))],
                    dim = c(ndim[-length(ndim)], year_range[2] - year_range[1] + 1))
    dimnm$year <- year_range[1]:year_range[2]
    dimnames(rs) <- dimnm
  }
  if (!return_array) stop('Need finish proramme')
  #if (get_only_lev_approx) {
  #  if (is.null(lev_approx)) 
  #    stop('Must define lev_approx for use get_only_lev_approx')
  #  
  #}
  rs
}

# Approximation with type 'UP', 'FX', 'LO'
data_frame_approximation <- function(frm, parameter, ...) {
  get_prefix <- function(frm, parameter, prf, pst) {
    f1 <- !is.na(frm[, paste(parameter, '.', prf, sep = '')])
    frm2 <- frm[f1, grep(paste('^', parameter, '[.]', sep = ''), colnames(frm), invert = TRUE)]
    frm2[, paste(parameter, '.', pst, sep = '')] <- frm[f1, paste(parameter, '.', prf, sep = '')]
    frm2 
  }
  for_test <- c('year', 'region', 'slice', 'group', 'comm')
    for(i in for_test[-1])
      if (any(i == colnames(frm)) && !is.factor(frm[, i])) frm[, i] <- as.factor(frm[, i])
  r1 <- simple_data_frame_approximation(rbind(get_prefix(frm, parameter, 'lo', 'lo'),
        get_prefix(frm, parameter, 'fx', 'lo')), paste(parameter, '.lo', sep = ''), ...)
  r2 <- simple_data_frame_approximation(rbind(get_prefix(frm, parameter, 'up', 'up'),
        get_prefix(frm, parameter, 'fx', 'up')), paste(parameter, '.up', sep = ''), ...)  
  if (any(dim(r1) != dim(r2)) || 
        any(sapply(1:length(dim(r1)), function(x) any(dimnames(r1)[[i]] != dimnames(r2)[[i]])))) {
          stop('Internal error')
  }
  yu <- array(c(r1, r2), dim = c(dim(r1), 2))
  ty <- dimnames(r1)
  ty[['type']] <- c('lo', 'up')    
  dimnames(yu) <- ty
  yu        
}



## Test
#frm <- data.frame(year = c(2005, NA, 2010), slice = c('W', 'S', 'W'), 
#        share.up = c(1, NA, NA), share.fx = c(NA, 3, NA), share.lo = c(NA, NA, 6), stringsAsFactors = FALSE)
#data_frame_approximation(frm, parameter = 'share', 
#          interpolation = interpolation, default_value = default_value, 
#                year_range = c(2008, 2009))
#
#                                            
##interpolation[1, 'cum'] <- 'back.inter.forth'
#default_value[1, 'cum'] <- 5
## Test: simple_data_frame_approximation
## Must work
#frm <- data.frame(year = c(2005, NA, 2010), slice = c('W', 'S', 'W'), cum = c(1, 3, 6))
#parameter = 'cum'
#rule = 'back'
#year_range = c(2006, 2050)
#simple_data_frame_approximation(frm, parameter = 'cum', 
#          interpolation = interpolation, default_value = default_value, 
#                year_range = c(2008, 2009))
#
#frm <- data.frame(year = c(NA, NA, 2008), slice = c('W', 'U', 'S'), cum = c(1, 3, 6))
#simple_data_frame_approximation(frm, parameter = 'cum', 
#      interpolation = interpolation, default_value = default_value, year_range = c(2006, 2050))
#
#frm <- data.frame(year = c(2005, 2007, NA), slice = c('W', 'S', 'O'), cum = c(1, 3, 6))
#simple_data_frame_approximation(frm, parameter = 'cum', 
#    interpolation = interpolation, default_value = default_value, year_range = c(2006, 2050))
#
#frm <- data.frame(region = c('AG', 'RU', 'RU'), year = c(2007, NA, 2005),
#          slice = c('W', 'S', 'O'), cum = c(1, 3, 6))
#simple_data_frame_approximation(frm, parameter = 'cum', interpolation = interpolation, 
#        default_value = default_value, year_range = c(2006, 2050))['AG',,]
#
## Must don't work
#frm <- data.frame(region = c(NA, 'RU', 'RU', 'BL'), year = c(2005, 2007, NA, 2007),
#          slice = c('W', 'S', 'O', 'O'), cum = c(1, 3, 6, 7))
#parameter = 'cum'
#rule = 'back'
#year_range = c(2006, 2050)
#simple_data_frame_approximation(frm, parameter = 'cum', interpolation = interpolation, 
#        default_value = default_value, year_range = c(2006, 2050))
#
#frm <- data.frame(year = c(2005, 2007, NA), slice = c('W', 'S', NA), cum = c(1, 3, 6))
#simple_data_frame_approximation(frm, parameter = 'cum', interpolation = interpolation, 
#  default_value = default_value, year_range = c(2006, 2050))
#
#frm <- data.frame(year = c(2005, 2007, NA), slice = c('W', 'O', 'O'), cum = c(1, 3, 6))
#simple_data_frame_approximation(frm, parameter = 'cum', interpolation = interpolation, 
#    default_value = default_value,)
#
#frm <- data.frame(year = c(2005, 2007, 2005), slice = c('W', 'S', NA), cum = c(1, 3, 6))
#simple_data_frame_approximation(frm, parameter = 'cum', interpolation = interpolation, 
#    default_value = default_value, year_range = c(2006, 2050))
#

