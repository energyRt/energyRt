pivot <- function(scen = NULL, variable = NULL, get_data = FALSE, ...) {
  #df <- arrayhelpers::array2df(scen@result@data[[var]], label.x = var)
  stopifnot(is.logical(get_data))
  if (class(scen) == "scenario") {scen <- list(scen)}
  stopifnot(is.list(scen))
  if (!is.list(variable)) {variable <- as.list(variable)}
  eg <- expand.grid(1:length(scen), 1:length(variable))
  lst <- mapply(function(x, y) {
    dft <- as.data.frame.table(scen[[x]]@result@data[[variable[[y]]]], 
                               responseName = "value") #[[y]])
    ii <- dft[, "value"] != 0
    dft <- dft[ii, ]
    if (nrow(dft) > 0) {
      dft$variable <- variable[[y]]
      dft$scen <- scen[[x]]@name
    } else {
      dft$variable <- character()
      dft$scen <- character()
    }
    return(list(dft))
  },
  x = eg[, 1], y = eg[, 2])
  
  dft <- Reduce(function(x, y, ...) {merge(x, y, all = TRUE)}, lst)
  #dft <- Reduce(function(x, y, ...) {dplyr::full_join(x, y)}, lst)
  
  if (get_data == F) {
    rpivotTable::rpivotTable(dft,
                             aggregatorName = "Sum",
                             rendererName = "Stacked Bar Chart",
                             cols = "year",
                             rows = c("tech", "comm", "sup", "dem"),
                             vals = "value", ...)
    
  } else {
    return(dft)
  }
}
