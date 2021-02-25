
.sm_to_glpk <-  function(obj) {
  if (obj@nValues != -1) {
    obj@data <- obj@data[seq(length.out = obj@nValues),]
  }
  if (obj@type == 'set') {
    if (nrow(obj@data) == 0) {
      ret <- c(paste('set ', obj@name, ' := ;', sep = ''), '')
    } else {
      ret <- c(paste('set ', obj@name, ' := ', paste(obj@data[[1]], collapse = ' '), ';', sep = ''), '')
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
      fl <- obj@data$value != Inf
      if (any(fl)) {
        ret <- c(ret, paste('[', apply(obj@data[fl, -ncol(obj@data), with = FALSE], 1, 
                                       function(x) paste(x, collapse = ',')), '] ', obj@data$value[fl], sep = ''))
      }
      if (ncol(obj@data) == 1) ret <- gsub('[[][ ]*[]]', '', ret)
      ret <- c(ret, ';', '')
    }
  } else if (obj@type == 'multi') {
    gg <- obj@data
    gg <- gg[gg$type == 'lo',]
    gg <- gg[, colnames(gg) != 'type', with = FALSE] 
    if (nrow(gg) == 0) { #  || all(gg$value[1] == gg$value)
      if (nrow(gg) == 0) dd <- obj@defVal[1] else dd <- gg$value[1]
      if (dd == Inf) dd <- 0
      ret <- paste('param ', obj@name, 'Lo default ', dd, ' := ;', sep = '')
    } else {
      dd <- obj@defVal[1]
      if (dd == Inf) dd <- 0
      ret <- paste('param ', obj@name, 'Lo default ', dd, ' := ', sep = '')
      fl <- gg$value != Inf
      if (any(fl)) {
        ret <- c(ret, paste('[', apply(gg[fl, -ncol(gg), with = FALSE], 1, 
                                       function(x) paste(x, collapse = ',')), '] ', gg$value[fl], sep = ''))
      }
      if (ncol(gg) == 1) ret <- gsub('[[][ ]*[]]', '', ret)
      ret <- c(ret, ';', '')
    }
    gg <- obj@data
    gg <- gg[gg$type == 'up',]
    gg <- gg[, colnames(gg) != 'type', with = FALSE] 
    if (nrow(gg) == 0) {  #  || all(gg$value[1] == gg$value)
      if (nrow(gg) == 0) dd <- obj@defVal[2] else dd <- gg$value[1]
      if (dd == Inf) dd <- 0
      ret <- c(ret, paste('param ', obj@name, 'Up default ', dd, ' := ;', sep = ''))
    } else {
      dd <- obj@defVal[2]
      if (dd == Inf) dd <- 0
      ret <- c(ret, paste('param ', obj@name, 'Up default ', dd, ' := ', sep = ''))
      fl <- gg$value != Inf
      if (any(fl)) {
        ret <- c(ret, paste('[', apply(gg[fl, -ncol(gg), with = FALSE], 1, 
                                       function(x) paste(x, collapse = ',')), '] ', gg$value[fl], sep = ''))
      }
      if (ncol(gg) == 1) ret <- gsub('[[][ ]*[]]', '', ret)
      ret <- c(ret, ';', '')
    }
  } else stop('Must realise')
  ret
}

