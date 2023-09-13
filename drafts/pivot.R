#' Title Pivot table for scenario objects, using _rpivotTable_ package
#'
#' @param scen  tbd
#' # Parameters to _getData_:
#' @param name tbd
#' @param get_data tbd 
#' @param ... tbd
#' # Parameters to _rpivotTable_:
#' @param aggregatorName tbd
#' @param rendererName tbd
#' @param cols tbd
#' @param rows tbd
#' @param vals tbd
#' @param sorter tbd
#' @param exclusions tbd 
#' @param inclusions tbd
#' @param locale tbd
#' @param subtotals tbd
#' @param width tbd
#' @param height tbd
#' @param elementId tbd
#'
#' 
pivot <- function(scen = NULL, 
                  # Parameters to _getData_:
                  name = NULL, get_data = FALSE, ...,
                  # Parameters to _rpivotTable_:
                  aggregatorName = "Sum",
                  rendererName = "Stacked Bar Chart",
                  cols = "year",
                  rows = c("tech", "comm", "sup", "dem"),
                  vals = "value",
                  sorter = NULL, exclusions = NULL,
                  inclusions = NULL, locale = "en", subtotals = FALSE, 
                  width = 800, height = 600, elementId = NULL) {
  stopifnot(is.logical(get_data))
  dft <- energyRt::getData(scen, name = name, merge = TRUE, ...)
  
  # if (is.null(aggregatorName)) aggregatorName = "Sum"
  # if (is.null(rendererName)) rendererName = "Stacked Bar Chart"
  # if (is.null(cols)) cols = "year"
  # if (is.null(rows)) rows = c("tech", "comm", "sup", "dem")
  # if (is.null(vals)) vals = "value"
  
  
  if (get_data == F) {
    rpivotTable::rpivotTable(dft,
                             aggregatorName = aggregatorName,
                             rendererName = rendererName,
                             cols = cols,
                             rows = rows,
                             vals = vals,
                             sorter = sorter, 
                             exclusions = exclusions,
                             inclusions = inclusions, 
                             locale = locale, 
                             subtotals = subtotals, 
                             width = width, 
                             height = height, 
                             elementId = elementId)
    
  } else {
    return(dft)
  }
}
