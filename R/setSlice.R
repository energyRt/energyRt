# setSlice(level1= 'MON', TH', ..., level2= '1H', 2H', ...)
# setSlice(level1= list(name 'WEEKDAY', 'MON' = 1/12, 'TH' = 1/13), ..., level2= '1H', 2H', ...)setSlice(level1= list('MON' = list(1/12, c('1H' = 1/13)), ...)

require(energyRt)
mdl <- new('model')
# set Slice name vectors
.setSlice <- function(mdl, ...) {
  arg <- list(...)
  check_colnames <- function(dtf, nm) {
    if (any(colnames(dtf) == nm) || any(grep('^[!A-z]', nm)) || any(gsub('[[:alnum:]]*', nm)))
      stop(paste('Wrong slice level names "', nm, '"', sep = ''))
  }
  check_slice <- function(nm) {
    if (any(grep('^[A-z]', nm, invert = TRUE)) || any(gsub('[[:alnum:]]*', '', nm) != '') || anyDuplicated(nm)) {
      n1 <- unique(c(grep('^[A-z]', nm, invert = TRUE, value = TRUE), nm[(gsub('[[:alnum:]]*', '', nm) != '')]))
      ms1 <- NULL; ms2 <- NULL; 
      if (length(n1) != 0) 
        ms1 <- paste('Wrong slice names "', paste(n1, collapse = '", "'), '". ', sep = '')
      n2 <- unique(nm[duplicated(nm)])
      if (length(n2) != 0) 
        ms2 <- paste('Wrong slice names "', paste(n2, collapse = '", "'), '"', sep = '')
      ms <- paste(ms1, ms2, sep = '')
      stop(ms)
    }
  }
  # Check full of slice sample
  check_full_slice <- function (dtf) {
    stop('check_full_slice')
  }
  slice_def <- function(dtf, arg) {
    while (length(arg) != 0) {
      if (!(is.character(arg[[1]]) || (!is.null(names(arg)) && !is.na(names(arg))[1]) && 
            is.list(arg[[1]])))
        stop(paste('.setSlice: Unknown argument: ', paste(capture.output(print(arg[[1]])), collapse = '\n'),
                   sep = '\n'))
      if (is.character(arg[[1]])) {
        lv <- arg[[1]];
        arg <- arg[-1]
      } else {
        lv <- names(arg)[1]
      }
      if (length(arg) == 0) 
        stop(paste('.setSlice: There are no slice for level "', lv, '"', sep = ''))
      dtf[, lv] <- rep(character(), nrow(dtf))
      if (is.character(arg[[1]]) || (!is.null(names(arg[[1]])) && is.numeric(arg[[1]]))) {
        if (is.character(arg[[1]])) {
          val_sh <- rep(1 / length(arg[[1]]), length(arg[[1]]))
          val_nm <- arg[[1]]
        } else {
          val_sh <- arg[[1]]
          val_nm <- names(arg[[1]])
        }
        check_slice(val_nm)
        if (any(val_nm <= 0) || sum(val_sh) != 1)
          stop(paste(paste('.setSlice: There are wronf slice data for level "', lv, '"\n', 
                           sep = ''), paste(capture.output(print(arg[[1]])), collapse = '\n'), sep = '\n'))
        arg <- arg[-1]
        dtf0 <- dtf; dtf <- dtf[0,, drop = FALSE];
        dtf[, lv] <- rep(character(), nrow(dtf))
        if (nrow(dtf0) != 0) {
          dtf[1:(nrow(dtf0) * length(val_sh)), ] <- NA
          for (i in 2:ncol(dtf0)) dtf[, i] <- dtf0[, i]
          dtf[, lv] <- c(t(matrix(val_nm, length(val_sh), nrow(dtf0))))
          dtf[, 'share'] <- (dtf0[, 'share'] * c(t(matrix(val_sh, length(val_sh), nrow(dtf0)))))
        } else {
          dtf[1:length(val_sh), ] <- NA
          dtf[, lv] <- val_nm
          dtf[, 'share'] <- val_sh
        }
      } else if (is.list(arg[[1]])) {
        dtf0 <- dtf
        while (length(arg) != 0) 
          dtf <- rbind(dtf, slice_def(dtf, arg[[1]]))
        arg <- arg[-1]
      } else stop(paste('.setSlice: Unknown type of argument for slice level "', lv, '"', sep = ''))
    }
    dtf
  }
  dtf <- data.frame(share = numeric(), stringsAsFactors = FALSE)
  dtf <- slice_def(dtf, arg)
  dtf[, c(2:ncol(dtf), 1), drop = FALSE]
}

arg <- list('lv', paste('x', 1:12, sep = ''))

.setSlice(mdl, 'lv', paste('x', 1:12, sep = ''))

.setSlice(mdl, lv1 = list(c('hh' = .5, 'gg' = .25, 'll' = .25)))


