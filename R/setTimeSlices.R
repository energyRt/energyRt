# setTimeSlices(level1= 'MON', TH', ..., level2= '1H', 2H', ...)
# setTimeSlices(level1= list(name 'WEEKDAY', 'MON' = 1/12, 'TH' = 1/13), ..., level2= '1H', 2H', ...)setTimeSlices(level1= list('MON' = list(1/12, c('1H' = 1/13)), ...)

# require(energyRt)
#mdl <- new('model')


.slice_check_data <- function(dtf) {
  if (ncol(dtf) < 2) stop(".setTimeSlices: slice data frame have to greate or equal two")
  if (colnames(dtf)[ncol(dtf)] != "share") stop(".setTimeSlices: last slice data frame have to name 'share'")
  rcs <- colnames(dtf)[-ncol(dtf)]
  if (anyDuplicated(rcs))
    stop(paste('.setTimeSlices: there are duplicated slice levels: "', 
               paste(unique(rcs[duplicated(rcs)]), collapse = '", "'), '"', sep = ''))
  fl <- apply(dtf[, -c(1, ncol(dtf)), with = FALSE], 2, function(x) length(unique(x)) == 1)
  if (any(fl)) 
    stop(paste('.setTimeSlices: all slice except first, have to consist from more than one slice, incorrect levels: "', 
               paste(colnames(dtf)[c(FALSE, fl, FALSE)], collapse = '", "'), '"', sep = ''))
  if (length(unique(dtf[, 1])) != 1)
    stop(".setTimeSlices: first slice have to consist only one slice")
  rcs <- c(apply(dtf[, -ncol(dtf), with = FALSE], 2, function(x) unique(x)), recursive = TRUE)
  if (anyDuplicated(rcs))
    stop(paste('.setTimeSlices: there are duplicated slice in different levels: "', 
               paste(unique(rcs[duplicated(rcs)]), collapse = '", "'), '"', sep = ''))
  # Check
  if (round(sum(dtf$share), 5) != 1) stop('.setTimeSlices: Sum of share have to be equal one, not: ', sum(dtf$share))
  ll <- apply(dtf[, -ncol(dtf), with = FALSE], 1, paste, collapse = '.')
  if (anyDuplicated(ll))
    stop(paste('.setTimeSlices: There are duplicate set of slice. ("',  paste(ll[duplicated(ll)], collapse = '", "'), '").', sep = ''))
  if (length(ll) != prod(sapply(dtf[, -ncol(dtf), with = FALSE], function(x) length(unique(x))))) {
    dtf2 <- unique(dtf[[1]])
    for (i in seq(length = ncol(dtf) - 2) + 1) {
      ln <- length(unique(dtf[[i]]))
      dtf2 <- paste(c(t(matrix(dtf2, length(dtf2), ln))), '.', unique(dtf[[i]]), sep = '')
    }
    stop(paste('.setTimeSlices: There are uncovered set of slice. ("',  paste(dtf2[!(dtf2 %in% ll)], collapse = '", "'), '").', sep = ''))
  }
}

# set Slice name vectors
.setTimeSlices <- function(slice = NULL, ...) {
  if (!is.null(slice) && length(list(...))) stop('setTimeSlices: only one argument could be define: "slice" or "..."')
  if (!is.null(slice)) {
    arg <- slice
  } else {
    arg <- list(...)
  }
  rcs <- names(arg)
  if (anyDuplicated(rcs))
    stop(paste('.setTimeSlices: there are duplicated slice levels: "', 
               paste(unique(rcs[duplicated(rcs)]), collapse = '", "'), '"', sep = ''))
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

  slice_def <- function(dtf, arg) {
    if (is.null(names(arg)) || any(names(arg) == ""))
      stop(paste('.setTimeSlices: Un named arguments: ', paste(capture.output(print(arg)), collapse = '\n'), sep = '\n'))
    add_val <- function(dtf, val_sh, val_nm, lv) {
      dtf0 <- dtf; 
      dtf <- dtf[0,];
      dtf[[lv]] <- character()
      if (nrow(dtf0) != 0) {
        dtf[1:(nrow(dtf0) * length(val_sh)), ] <- NA
        dtf <- dtf %>% add_row(share = (dtf0[['share']] * c(t(matrix(val_sh, length(val_sh), nrow(dtf0))))))
        for (i in 2:ncol(dtf0)) dtf[[i]] <- dtf0[[i]]
        dtf[[lv]] <- c(t(matrix(val_nm, length(val_sh), nrow(dtf0))))
      } else {
        dtf <- dtf %>% add_row(share = val_sh)
        dtf[[lv]] <- val_nm
      }
      dtf
    }
    while (length(arg) != 0) {
      lv <- names(arg)[1]
      dtf[[lv]] <- rep(character(), nrow(dtf))
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
          stop(paste(paste('.setTimeSlices: There are wrong slice data for level "', lv, '"\n', 
                           sep = ''), paste(capture.output(print(arg[[1]])), collapse = '\n'), sep = '\n'))
        arg <- arg[-1]
        dtf <- add_val(dtf, val_sh, val_nm, lv)
      } else if (is.list(arg[[1]])) {
        arg2 <- arg[[1]]; #arg <- arg[-1]
        if (is.null(names(arg2)) || any(names(arg2) == ''))
          stop(paste(paste('.setTimeSlices: There are wrong slice data for level "', lv, '"\n', 
                           sep = ''), paste(capture.output(print(arg[[1]])), collapse = '\n'), sep = '\n'))
        if (is.numeric(arg2[[1]])) {
          if (!all(sapply(arg2, is.numeric)))
            stop(paste(paste('.setTimeSlices: There are wrong slice data for level "', lv, '"\n', 
                             sep = ''), paste(capture.output(print(arg[[1]])), collapse = '\n'), sep = '\n'))
          dtf <- add_val(dtf, c(arg2, recursive = TRUE), names(arg2), lv)
          arg <- arg[-1]
        } else {
          if (!all(sapply(arg2, is.list)))
            stop(paste(paste('.setTimeSlices: There are wrong slice data for level "', lv, '"\n', 
                             sep = ''), paste(capture.output(print(arg[[1]])), collapse = '\n'), sep = '\n'))
          dtf0 <- dtf;
          dtf <- NULL
          arg2 <- arg[[1]]; 
          for (i in seq(length.out = length(arg2))) { 
            dtf1 <- slice_def(add_val(dtf0, arg2[[i]][[1]], names(arg2)[i]), arg2[[i]][-1], lv)
            if (i == 1) {
              dtf <- dtf1
            } else {
              if (ncol(dtf) != ncol(dtf1) || any(colnames(dtf) != colnames(dtf1)))
                stop(paste('.setTimeSlices: Set of slice have to be the same for all (check list slice arguments).', sep = ''))
              dtf <- rbind(dtf, dtf1)
            }
          }
          arg <- arg[-1]
        }
      } else stop(paste('.setTimeSlices: Unknown type of argument for slice level "', lv, '"', sep = ''))
    }
    dtf
  }
  dtf <- data.table(share = numeric(), stringsAsFactors = FALSE)
  if (length(arg) == 1 && is.character(arg[[1]]) && length(arg[[1]]) == 1) {
    dtf <- data.table(share = 1, ANNUAL = arg[[1]], stringsAsFactors = FALSE)
    if (!is.null(names(arg))) colnames(dtf)[2] <- names(arg)[1] 
  } else {
    dtf <- slice_def(dtf, arg)
  }
  dtf <- setcolorder(dtf, c(2:ncol(dtf), 1))
  if (length(unique(dtf[, 1])) != 1) {
    warning('.setTimeSlices: first slice have to consist only one slice, add "ANNUAL"')
    if (any(colnames(dtf) == 'ANNUAL') || any(c(dtf == "ANNUAL", recursive = TRUE)))
      stop('.setTimeSlices: cannot add level "ANNUAL" slice, with level "ANNUAL"')
    dtf$ANNUAL  <- rep('ANNUAL', nrow(dtf))
    dtf <- dtf[, c(ncol(dtf), 2:ncol(dtf) - 1), drop = FALSE]
  }
  if (abs(sum(dtf$share) - 1) < 1e-10) dtf$share <- (dtf$share / sum(dtf$share))
  .slice_check_data(dtf)
  sl <- new('slice')
  sl@levels <- dtf
  sl <- .init_slice(sl)
  sl
}

setGeneric("setTimeSlices", function(obj, ...) standardGeneric("setTimeSlices"))

setMethod('setTimeSlices', signature(obj = 'model'), function(obj, ...) {
  obj@sysInfo@slice <- .setTimeSlices(...)
  obj
})
                              
setMethod('setTimeSlices', signature(obj = 'scenario'), function(obj, ...) {
  obj@model@sysInfo@slice <- .setTimeSlices(...)
  obj
})

setMethod('setTimeSlices', signature(obj = 'sysInfo'), function(obj, ...) {
  obj@slice <- .setTimeSlices(...)
  obj
})

timeSlices <- function(x, asTibble = T, stringsAsFactors = FALSE) {
  # invisible(newModel("dummymod", slice = xx)@sysInfo@slice)
  mm <- newModel("dummymod", slice = x)
  slev <- mm@sysInfo@slice@levels
  nlev <- length(mm@sysInfo@slice@slice_map)
  if (nlev == 1)  slev$slice <- slev$ANNUAL else
    slev$slice <- apply(slev[, 2:nlev, drop = FALSE], 1, paste0, collapse = '_')
  if (!stringsAsFactors) slev <- fact2char(slev)
  if (asTibble) slev <- tibble::as_tibble(slev)
  slev
}

#! 1
# .setTimeSlices("SEASON" = c("WINTER", "SUMMER"))
# .setTimeSlices("SEASON" = c("WINTER" = .6, "SUMMER" = .4))
# .setTimeSlices("SEASON" = list("WINTER" = .6, "SUMMER" = .4))
# .setTimeSlices("SEASON" = list("WINTER" = list(.3, DAY = c('MORNING', 'EVENING')), "SUMMER" = list(.7, DAY = c('MORNING', 'EVENING'))))
# .setTimeSlices("SEASON" = list("WINTER" = list(.3, DAY = c('MORNING')), "SUMMER" = list(.7, DAY = c('MORNING', 'EVENING')))) # have to error

#! 2
#.setTimeSlices("SEASON" = c("WINTER", "SUMMER"), HOUR = paste('H', seq(0, 21, by = 3), sep = ''))
#.setTimeSlices("SEASON" = list("WINTER" = list(.3, DAY = list('MORNING' = list(.5, tp = c('x1' = .1, 'x2' = .9)), 'EVENING' = list(.5, tp = c('x1', 'x2')))), 
#                          "SUMMER" = list(.7, DAY = list('MORNING' = list(.5, tp = c('x1', 'x2')), 'EVENING' = list(.5, tp = c('x1', 'x2'))))))

# sl = .setTimeSlices("SEASON" = list("WINTER" = list(.3, DAY = c('MORNING', 'EVENING', 'PEAK')), "SUMMER" = list(.7, DAY = c('MORNING', 'EVENING', 'PEAK'))))
