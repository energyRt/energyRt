mileStoneYears <- function(obj) {
  if (any(class(obj) == 'model')) {
    mileStoneYears(obj@sysInfo)
  } else if (any(class(obj) == 'sysInfo')) {
      obj@milestone
  } else stop('mileStoneYears: undefined class')
}

setMileStoneYears <- function(obj, start, ...) {
  if (any(class(obj) == 'model')) {
    obj@sysInfo <- setMileStoneYears(obj@sysInfo, start, ...)
    obj
  } else if (any(class(obj) == 'sysInfo')) {
    arg <- list(...)
    if (any(!(names(arg) %in% c('interval', 'end', 'by')))) {
      stop('setMileStoneYears: Wrong argument')
    }
    if (any(names(arg) == 'interval')) {
      if (length(arg) != 1)  stop('setMileStoneYears: Wrong argument')
      if (arg$interval[1] != 1)  stop('setMileStoneYears: first interval have to be 1')
      interval <- arg$interval
    } else {
      if (!any(names(arg) == 'end') || !any(names(arg) == 'by') || length(arg) != 2) 
        stop('setMileStoneYears: Wrong argument')
      if ((arg$end - start) %% arg$by == 0 && arg$by != 1) {
        warning('setMileStoneYears: (Start - End) %% by have to be 1, add 1 year in the begining')
        interval <- seq(start + 1, arg$end, by = arg$by) - start
      } else if ((arg$end - start) %% arg$by == 1 || arg$by == 1) {
        interval <- seq(start + 1, arg$end, by = arg$by)
        interval <- c(1, interval[-1] - interval[-length(interval)])
        print(interval)
      } else stop('setMileStoneYears: Wrong argument')
    }
    mlst <- data.frame(start = start + cumsum(c(0, interval[-length(interval)])), 
      mid = rep(NA, length(interval)), end = start + cumsum(interval) - 1)
    mlst[, 'mid'] <- trunc(.5 * (mlst[, 'start'] + mlst[, 'end']))
    obj@milestone <- mlst
    obj 
  } else stop('setMileStoneYears: undefined class')
}

