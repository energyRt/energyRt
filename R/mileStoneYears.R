#setMilestoneYears <- function(obj, start, ...) {
#  if (any(class(obj) == 'model')) {
#    obj@sysInfo <- setMileStoneYears(obj@sysInfo, start, ...)
#    obj
#  } else if (any(class(obj) == 'sysInfo')) {
#    arg <- list(...)
#    if (any(!(names(arg) %in% c('interval', 'end', 'by')))) {
#    if (any(!(names(arg) %in% c('interval')))) {
#      stop('setMileStoneYears: Wrong argument')
#    }
#    if (any(names(arg) == 'interval')) {
#      if (length(arg) != 1)  stop('setMileStoneYears: Wrong argument')
#      if (arg$interval[1] != 1)  stop('setMileStoneYears: first interval have to be 1')
#      interval <- arg$interval
#    } else {
#      if (!any(names(arg) == 'end') || !any(names(arg) == 'by') || length(arg) != 2) 
#        stop('setMileStoneYears: Wrong argument')
#      if ((arg$end - start) %% arg$by != 0) {
#        interval <- c(1, NA, rep(arg$by, (arg$end - start) %/% arg$by))
#        interval[2] <- arg$end - start + 1 - sum(interval[-2])
#        warning('setMileStoneYears: (Start - End) %% by have to be 0, add ', interval[2], ' years in the begining')
#      } else if ((arg$end - start) %% arg$by == 0) {
#        interval <- c(1, rep(arg$by, (arg$end - start) %/% arg$by))
#      } else stop('setMileStoneYears: Wrong argument')
#    }
#    mlst <- data.table(start = start + cumsum(c(0, interval[-length(interval)])), 
#      mid = rep(NA, length(interval)), end = start + cumsum(interval) - 1)
#    mlst[, 'mid'] <- trunc(.5 * (mlst[, 'start'] + mlst[, 'end']))
#    obj@milestone <- mlst
#    obj@year <- start:(start + sum(interval) - 1)
#    obj 
#  } else stop('setMileStoneYears: undefined class')
#}

setMethod('setMilestoneYears', signature(obj = 'sysInfo', start = 'numeric', interval = 'numeric'), 
  function(obj, start, interval) {
    obj@milestone <- milestoneYears(start, interval)
    obj@year <- min(obj@milestone$start):max(obj@milestone$end)
    obj
})

setMethod('setMilestoneYears', signature(obj = 'model', start = 'numeric', interval = 'numeric'), 
  function(obj, start, interval) {
    obj@sysInfo <- setMilestoneYears(obj@sysInfo, start, interval)
    obj
})
setMethod('setMilestoneYears', signature(obj = 'scenario', start = 'numeric', interval = 'numeric'), 
  function(obj, start, interval) {
    obj@model <- setMilestoneYears(obj@model, start, interval)
    obj
})

setMethod('milestoneYears', signature(start = 'numeric', interval = 'numeric'), function(start, interval) {
      if (interval[1] != 1)  stop('setMileStoneYears: first interval have to be 1')
    mlst <- data.table(start = start + cumsum(c(0, interval[-length(interval)])), 
      mid = rep(NA, length(interval)), end = start + cumsum(interval) - 1)
    mlst[, 'mid'] <- trunc(.5 * (mlst[, 'start'] + mlst[, 'end']))
    mlst
})



setMethod('getMilestone', signature(obj = 'scenario'), function(obj) {
    getMilestone(obj@model)
})
setMethod('getMilestone', signature(obj = 'model'), function(obj) {
    getMilestone(obj@sysInfo)
})
setMethod('getMilestone', signature(obj = 'sysInfo'), function(obj) {
    obj@milestone
})


