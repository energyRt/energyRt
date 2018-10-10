pivot <- function(scen = NULL, name = NULL, get_data = FALSE, ...) {
  stopifnot(is.logical(get_data))
  dft <- getData(scen, name = name, merge = TRUE, ...)
  
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
