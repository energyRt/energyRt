.getUniversalNames <- function(obj, cls, regex = NULL, ignore.case = FALSE, 
  fixed = FALSE, useBytes = FALSE, invert = FALSE, ...) {
  if (is.null(regex)) {
    grep2 <- function(x, y, FL) {
      if (FL) {
        grep(x, as.character(y), ignore.case = ignore.case, fixed = fixed, 
                                     useBytes = useBytes, invert = invert)
      } else {
        y %in% x
      }
    }
  } else if (regex) {
    grep2 <- function(x, y, FL) grep(x, as.character(y), ignore.case = ignore.case, fixed = fixed, 
                      useBytes = useBytes, invert = invert)
  } else {
    grep2 <- function(x, y, FL) y %in% x
  }
  arg <- list(...)
  if (any(class(obj) == 'scenario')) obj <- obj@model
  if (any(class(obj) == 'repository')) {
    obj <- add(new('model'), obj)
  }
  if (is.null(cls)) {
    lst <- list()
    cls <- unique(c(lapply(obj@data, function(xx) unique(sapply(xx@data, class))), recursive = TRUE))
    for(cl in cls) {
      ll <- energyRt:::.getUniversalNames(obj, cl, regex = regex, ignore.case = ignore.case, fixed = fixed, 
        useBytes = useBytes, invert = invert, ...)
      for(i in seq(along = ll))
        lst[[names(ll)[i]]] <- ll[[i]]
    }                                                         
    lst
  } else {
    rst <- data.table(rp = numeric(), ob = numeric(), use = logical())
    for(i in seq(along = obj@data)) {
      jj <- seq(along = obj@data[[i]]@data)[sapply(obj@data[[i]]@data, class) == cls]
      if (length(jj) != 0) {
        nn <- nrow(rst) + 1:length(jj)
        rst[nn, ] <- NA
        rst[nn, 'rp'] <- i
        rst[nn, 'ob'] <- jj
        rst[nn, 'use'] <- TRUE
      }
    }
    s1 <- getSlots(cls)
    s2 <- new(cls)
    FL <- rep(FALSE, length(arg))
    FL[grep('[_]$', names(arg))] <- TRUE
    names(arg) <- gsub('[_]$', '', names(arg))
    names(FL) <- names(arg)
    for(a in seq(along = arg)) {
      if (all(names(s1) != names(arg)[a])) {
          rst <- rst[0,, drop = FALSE]
      } else {  
      if (nrow(rst) > 0) {
        error_msg <- paste('getUniversalName: undefined condition argument "', names(arg)[a], 
                '" for class "', cls, '"', sep = '')
        nm <- names(arg)[a]
        cnd <- arg[[a]]
        if (s1[nm] == 'list') stop(error_msg)
        if (s1[nm] %in% c("character", 'factor')) {
        # Character
         if (!(class(cnd)  %in% c("character", 'factor'))) stop(error_msg)
          for(i in seq(length.out = nrow(rst))) 
            rst[i, 'use']  <- any(grep2(cnd, slot(obj@data[[rst[i, 1]]]@data[[rst[i, 2]]], nm), FL[nm]))
          rst <- rst[rst$use,, drop = FALSE]
        } else if (s1[nm] == "logical") {
        # Logical
          if (class(cnd) != 'logical') stop(error_msg)
          for(i in seq(length.out = nrow(rst)))
            rst[i, 'use']  <- any(cnd == slot(obj@data[[rst[i, 1]]]@data[[rst[i, 2]]], nm), na.rm = TRUE)
          rst <- rst[rst$use,, drop = FALSE]
        } else if (s1[nm] == "numeric") {      
        # Numeric
          if (!(class(cnd) %in% c('integer', 'numeric'))) stop(error_msg)
            if (is.null(names(cnd)) && length(cnd) > 2) stop(error_msg)
            if (is.null(names(cnd)) && length(cnd) == 2) names(cnd) <- c('ge', 'le')
            if (is.null(names(cnd)) && length(cnd) == 1) names(cnd) <- 'e'
            if (any(!(names(cnd) %in% c('l', 'le', 'e', 'ge', 'g', 'ne')))) stop(error_msg)
            if (any(names(cnd) == 'le')) {       
              for(i in seq(length.out = nrow(rst)))
                rst[i, 'use'] <- any(cnd['le'] >= slot(obj@data[[rst[i, 1]]]@data[[rst[i, 2]]], nm), na.rm = TRUE)
                rst <- rst[rst$use,, drop = FALSE]
            }
            if (any(names(cnd) == 'l')) {       
              for(i in seq(length.out = nrow(rst)))
                rst[i, 'use']  <- any(cnd['l'] > slot(obj@data[[rst[i, 1]]]@data[[rst[i, 2]]], nm), na.rm = TRUE)
                rst <- rst[rst$use,, drop = FALSE]
            }
            if (any(names(cnd) == 'e')) {       
              for(i in seq(length.out = nrow(rst)))
                rst[i, 'use']  <- any(cnd['e'] == slot(obj@data[[rst[i, 1]]]@data[[rst[i, 2]]], nm), na.rm = TRUE)
                rst <- rst[rst$use,, drop = FALSE]
            }
            if (any(names(cnd) == 'ge')) {       
              for(i in seq(length.out = nrow(rst)))
                rst[i, 'use'] <- any(cnd['ge'] <= slot(obj@data[[rst[i, 1]]]@data[[rst[i, 2]]], nm), na.rm = TRUE)
                rst <- rst[rst$use,, drop = FALSE]
            }
            if (any(names(cnd) == 'g')) {       
              for(i in seq(length.out = nrow(rst)))
                rst[i, 'use']  <- any(cnd['g'] < slot(obj@data[[rst[i, 1]]]@data[[rst[i, 2]]], nm), na.rm = TRUE)
                rst <- rst[rst$use,, drop = FALSE]
            }
            if (any(names(cnd) == 'ne')) {       
              for(i in seq(length.out = nrow(rst)))
                rst[i, 'use'] <- any(cnd['ne'] != slot(obj@data[[rst[i, 1]]]@data[[rst[i, 2]]], nm), na.rm = TRUE)
                rst <- rst[rst$use,, drop = FALSE]
            }
        } else if (s1[nm] == "data.table") {
        # data.table
          FL2 <- rep(FALSE, length(cnd))
          FL2[grep('[_]$', names(cnd))] <- TRUE
          names(cnd) <- gsub('[_]$', '', names(cnd))
          names(FL2) <- names(cnd)
          for(nm2 in names(cnd)) {
            cnd2 <- cnd[[nm2]]       
            if (all(colnames(slot(s2, nm)) != nm2)) stop(error_msg)
            # Character
            if (class(cnd2)  %in% c("character", 'factor')) {
              if (!(class(cnd2)  %in% c("character", 'factor'))) stop(error_msg)
              for(i in seq(length.out = nrow(rst))) 
                rst[i, 'use']  <- any(grep2(cnd2, 
                       slot(obj@data[[rst[i, 1]]]@data[[rst[i, 2]]], nm)[, nm2], FL2[nm2]), na.rm = TRUE)
              rst <- rst[rst$use,, drop = FALSE]
            } else if (class(cnd2) == "logical") {
            # Logical
              if (class(cnd2) != 'logical') stop(error_msg)
              for(i in seq(length.out = nrow(rst)))
                rst[i, 'use']  <- any(cnd == 
                  slot(obj@data[[rst[i, 1]]]@data[[rst[i, 2]]], nm)[, nm2], na.rm = TRUE)
              rst <- rst[rst$use,, drop = FALSE]
            } else if (class(cnd2) == "numeric") {
            # Numeric
              if (!(class(slot(s2, nm)[, nm2]) %in% c('integer', 'numeric'))) stop(error_msg)
              if (is.null(names(cnd2)) && length(cnd2) > 2) stop(error_msg)
              if (is.null(names(cnd2)) && length(cnd2) == 2) names(cnd2) <- c('ge', 'le')
              if (is.null(names(cnd2)) && length(cnd2) == 1) names(cnd2) <- 'e'
              if (any(!(names(cnd2) %in% c('l', 'le', 'e', 'ge', 'g', 'ne')))) stop(error_msg)
              if (any(names(cnd2) == 'le')) {       
                for(i in seq(length.out = nrow(rst)))
                  rst[i, 'use']  <- any(cnd2['le'] >= 
                    slot(obj@data[[rst[i, 1]]]@data[[rst[i, 2]]], nm)[, nm2], na.rm = TRUE)
                  rst <- rst[rst$use,, drop = FALSE]
              }
              if (any(names(cnd2) == 'l')) {       
                for(i in seq(length.out = nrow(rst)))
                  rst[i, 'use']  <- any(cnd2['l'] > 
                    slot(obj@data[[rst[i, 1]]]@data[[rst[i, 2]]], nm)[, nm2], na.rm = TRUE)
                  rst <- rst[rst$use,, drop = FALSE]
              }
              if (any(names(cnd2) == 'e')) {       
                for(i in seq(length.out = nrow(rst)))
                  rst[i, 'use']  <- any(cnd2['e'] == 
                    slot(obj@data[[rst[i, 1]]]@data[[rst[i, 2]]], nm)[, nm2], na.rm = TRUE)
                  rst <- rst[rst$use,, drop = FALSE]
              }
              if (any(names(cnd2) == 'ge')) {       
                for(i in seq(length.out = nrow(rst)))
                  rst[i, 'use']  <- any(cnd2['ge'] <= 
                    slot(obj@data[[rst[i, 1]]]@data[[rst[i, 2]]], nm)[, nm2], na.rm = TRUE)
                  rst <- rst[rst$use,, drop = FALSE]
              }
              if (any(names(cnd2) == 'g')) {       
                for(i in seq(length.out = nrow(rst)))
                  rst[i, 'use']  <- any(cnd2['g'] < 
                    slot(obj@data[[rst[i, 1]]]@data[[rst[i, 2]]], nm)[, nm2], na.rm = TRUE)
                  rst <- rst[rst$use,, drop = FALSE]
              }
              if (any(names(cnd2) == 'ne')) {       
                for(i in seq(length.out = nrow(rst)))
                  rst[i, 'use']  <- any(cnd2['ne'] != 
                    slot(obj@data[[rst[i, 1]]]@data[[rst[i, 2]]], nm)[, nm2], na.rm = TRUE)
                  rst <- rst[rst$use,, drop = FALSE]
              }
            }   else stop(error_msg)
          }
        }
      }
    }
    }
    nn <- list()
    for(i in seq(length.out = nrow(rst)))
      nn[[obj@data[[rst[i, 1]]]@data[[rst[i, 2]]]@name]] <- obj@data[[rst[i, 1]]]@data[[rst[i, 2]]]
    nn
  }
}


getNames <- function(obj, class = c(), regex = NULL, ...) {
  names(energyRt:::.getUniversalNames(obj, cls = class, regex = regex, ...))
}
getNames_ <- function(obj, class = c(), ...) {
  names(energyRt:::.getUniversalNames(obj, cls = class, regex = TRUE, ...))
}


getObjects <- function(obj, class = c(), regex = NULL, ...) {   
  energyRt:::.getUniversalNames(obj, cls = class, regex = regex, ...)
}

getObjects_ <- function(obj, class = c(), ...) {   
  energyRt:::.getUniversalNames(obj, cls = class, regex = TRUE, ...)
}





