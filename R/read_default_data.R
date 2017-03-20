read_default_data <- function(prec, ss) {
  for(i in seq(along = prec@parameters)) {
    if (any(prec@parameters[[i]]@colName != '')) {
      prec@parameters[[i]]@defVal <-
        as.numeric(ss@defVal[1, prec@parameters[[i]]@colName])
      prec@parameters[[i]]@interpolation <-
        as.character(ss@interpolation[1, prec@parameters[[i]]@colName])
    }
  }
  prec
}