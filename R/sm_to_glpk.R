
.sm_to_glpk <-  function(obj) {
  if (obj@nValues != -1) {
    obj@data <- obj@data[seq(length.out = obj@nValues),, drop = FALSE]
  }
  if (obj@type == 'set') {
    if (nrow(obj@data) == 0) {
      ret <- c(paste('set ', obj@name, ' := 1;', sep = ''), '')
    } else {
      ret <- c(paste('set ', obj@name, ' := ', paste(obj@data[, 1], collapse = ' '), ';', sep = ''), '')
    }
  } else if (obj@type == 'map') {
    if (nrow(obj@data) == 0) {
      ret <- paste('set ', obj@name, ' := ;', sep = '')
    } else {
      ret <- paste('set ', obj@name, ' := ', sep = '')
      ret <- c(ret, apply(obj@data, 1, function(x) paste(paste(x, collapse = ' '), ', ', sep = '')))
      ret <- c(ret, ';', '')
    }
  } else if (obj@type == 'simple') {
    if (nrow(obj@data) == 0) {
      dd <- obj@defVal
      if (dd == Inf) dd <- 0
      ret <- paste('param ', obj@name, ' default ', dd, ' := ;', sep = '')
    } else {
      dd <- obj@defVal
      if (dd == Inf) dd <- 0
      ret <- paste('param ', obj@name, ' default ', dd, ' := ', sep = '')
      fl <- obj@data[, 'value'] != Inf
      if (any(fl)) {
        ret <- c(ret, paste('[', apply(obj@data[fl, -ncol(obj@data), drop = FALSE], 1, 
                                       function(x) paste(x, collapse = ',')), '] ', obj@data[fl, 'value'], sep = ''))
      }
      ret <- c(ret, ';', '')
    }
  } else if (obj@type == 'multi') {
    gg <- obj@data
    gg <- gg[gg$type == 'lo', , drop = FALSE]
    gg <- gg[, colnames(gg) != 'type'] 
    if (nrow(gg) == 0 || all(gg$value[1] == gg$value)) {
      if (nrow(gg) == 0) dd <- obj@defVal[1] else dd <- gg$value[1]
      if (dd == Inf) dd <- 0
      ret <- paste('param ', obj@name, 'Lo default ', dd, ' := ;', sep = '')
    } else {
      dd <- obj@defVal[1]
      if (dd == Inf) dd <- 0
      ret <- paste('param ', obj@name, 'Lo default ', dd, ' := ', sep = '')
      fl <- gg[, 'value'] != Inf
      if (any(fl)) {
        ret <- c(ret, paste('[', apply(gg[fl, -ncol(gg), drop = FALSE], 1, 
                                       function(x) paste(x, collapse = ',')), '] ', gg[fl, 'value'], sep = ''))
      }
      ret <- c(ret, ';', '')
    }
    gg <- obj@data
    gg <- gg[gg$type == 'up', , drop = FALSE]
    gg <- gg[, colnames(gg) != 'type'] 
    if (nrow(gg) == 0 || all(gg$value[1] == gg$value)) {
      if (nrow(gg) == 0) dd <- obj@defVal[2] else dd <- gg$value[1]
      if (dd == Inf) dd <- 0
      ret <- c(ret, paste('param ', obj@name, 'Up default ', dd, ' := ;', sep = ''))
    } else {
      dd <- obj@defVal[2]
      if (dd == Inf) dd <- 0
      ret <- c(ret, paste('param ', obj@name, 'Up default ', dd, ' := ', sep = ''))
      fl <- gg[, 'value'] != Inf
      if (any(fl)) {
        ret <- c(ret, paste('[', apply(gg[fl, -ncol(gg), drop = FALSE], 1, 
                                       function(x) paste(x, collapse = ',')), '] ', gg[fl, 'value'], sep = ''))
      }
      ret <- c(ret, ';', '')
    }
  } else stop('Must realise')
  ret
}

