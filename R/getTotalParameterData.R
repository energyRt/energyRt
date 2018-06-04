.getTotalParameterData <- function(prec, name) {
  dtt <- getParameterData(prec@parameters[[name]])
  approxim <- lapply(prec@parameters[[name]]@dimSetNames, function(x)
    getParameterData(prec@parameters[[x]])[, x])
  names(approxim) <- prec@parameters[[name]]@dimSetNames
  if (prec@parameters[[name]]@type == 'multi') approxim$type <- c('lo', 'up')
  if (nrow(dtt) == prod(sapply(approxim, length))) 
    return(dtt)
  # Create full set array
  gg <- data.frame(stringsAsFactors = FALSE)
  for (i in names(approxim)) gg[, i] <- character()
  gg[, 'value'] <- numeric()
  gg[prod(sapply(approxim, length)), ] <- NA
  k <- 1
  for (i in names(approxim)) {
    nl <- length(approxim[[i]])
    gg[, i] <- approxim[[i]][c(t(matrix(1:nl, nl, k)))]
    k <- k * nl
  }
  gg[, 'value'] <- prec@parameters[[name]]@defVal[1]
  if (prec@parameters[[name]]@type == 'multi') 
    gg[gg$type == 'up', 'value'] <- prec@parameters[[name]]@defVal[2]
  # reduce set array
  f1 <- apply(dtt[, -ncol(dtt)], 1, paste, collapse = '##')
  f2 <- apply(gg[, -ncol(gg)], 1, paste, collapse = '##')
  rbind(dtt, gg[!(f2 %in% f1),, drop = FALSE])
}
