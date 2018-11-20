.setParameterData <- function(prec, name, dtf) {
  stopifnot(ncol(dtf) == ncol(prec@parameters[[name]]@data) && 
    all(colnames(prec@parameters[[name]]@data) == colnames(dtf)))
  prec@parameters[[name]]@data <- dtf
  if (prec@parameters[[name]]@nValues != -1) {
    prec@parameters[[name]]@nValues <- nrow(dtf)
  } 
  prec@parameters[[name]]@not_data <- FALSE
  prec
}
