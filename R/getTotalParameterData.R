.getTotalParameterData <- function(prec, name, need.reduce = TRUE) {
  reduce.duplicate <- function(x) x[!duplicated(x),, drop = FALSE]
  getAllDefVal <- function(prec, name) {
    sets0 <- prec@parameters[[name]]@dimSetNames
    sets <- NULL
    for (i in sets0) {
      j <- i
      if (any(i == c('src', 'dst'))) j <- 'region'
      tmp <- getParameterData(prec@parameters[[j]])
      colnames(tmp) <- i
      if (need.reduce) {
        if (i == 'slice' && any(colnames(sets) == 'comm')) {
          tmp <- merge(getParameterData(prec@parameters$mCommSlice), tmp)
        } 
        if (i == 'comm' && any(colnames(sets) == 'sup')) {
          tmp <- merge(getParameterData(prec@parameters$mSupComm), tmp)
        }      
        if (i == 'region' && any(colnames(sets) == 'sup') && all(sets0 != 'year')) {
          tmp <- merge(reduce.duplicate(getParameterData(prec@parameters$mSupSpan)[, c('sup', 'region')]), tmp)
        }      
        if (i == 'year' && any(colnames(sets) == 'sup') && any(colnames(sets) == 'region')) {
          tmp <- merge(getParameterData(prec@parameters$mSupSpan), tmp)
        }      
        if (i == 'year') {
          tmp <- merge(getParameterData(prec@parameters$mMidMilestone), tmp)
        }
        if (i == 'year' && any(colnames(sets) == 'tech')) {
          tmp <- merge(getParameterData(prec@parameters$mTechSpan), tmp)
        }
        if (i == 'region' && any(colnames(sets) == 'tech') && all(sets0 != 'year')) {
          tmp <- merge(reduce.duplicate(getParameterData(prec@parameters$mTechSpan)[, c('tech', 'region')]), tmp)
        }
        
        if (i == 'comm' && any(colnames(sets) == 'tech')) {
          tmp <- merge(rbind(getParameterData(prec@parameters$mTechInpComm), getParameterData(prec@parameters$mTechOutComm)), tmp)
        }
        if (i == 'slice' && any(colnames(sets) == 'tech')) {
          tmp <- merge(getParameterData(prec@parameters$mTechSlice), tmp)
        }
        if (i == 'src') {
          aa <- getParameterData(prec@parameters$mTradeSrc)
          colnames(aa)[2] <- 'src'
          tmp <- merge(aa, tmp)
        }
        if (i == 'dst') {
          aa <- getParameterData(prec@parameters$mTradeDst)
          colnames(aa)[2] <- 'dst'
          tmp <- merge(aa, tmp)
        }
        if (i == 'comm' && any(colnames(sets) == 'trade')) {
          tmp <- merge(getParameterData(prec@parameters$mTradeComm), tmp)
        }
      }
      if (is.null(sets)) {
        sets <- tmp
      } else {
        sets <- merge(sets, tmp)
      }
    }
    if (prec@parameters[[name]]@type == 'simple' && (is.null(sets) || nrow(sets) != 0)) {
      sets$value <- prec@parameters[[name]]@defVal
      if (!is.data.frame(sets)) sets <- as.data.frame(sets)
    } 
    if (prec@parameters[[name]]@type == 'multi' && (is.null(sets) || nrow(sets) != 0)) {
      sets$type <- 'lo'
      sets$value <- prec@parameters[[name]]@defVal[1]
      sets2 <- sets
      sets2$type <- 'up'
      sets2$value <- prec@parameters[[name]]@defVal[2]
      sets <- rbind(sets, sets2)
    } 
    sets
  }
  tmp <- getAllDefVal(prec, name)
  dtt <- getParameterData(prec@parameters[[name]])
  gg <- rbind(dtt, tmp)
  if (ncol(gg) == 1) return(dtt)
  gg[!duplicated(gg[, colnames(gg) != 'value']),, drop = FALSE]
}
