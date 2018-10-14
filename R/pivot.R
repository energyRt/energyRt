#' Title Pivot table for scenario objects, using _rpivotTable_ package
#'
#' @param scen 
#' # Parameters to _getData_:
#' @param name 
#' @param get_data 
#' @param ... 
#' # Parameters to _rpivotTable_:
#' @param aggregatorName 
#' @param rendererName 
#' @param cols 
#' @param rows 
#' @param vals 
#' @param sorter 
#' @param exclusions 
#' @param inclusions 
#' @param locale 
#' @param subtotals 
#' @param width 
#' @param height 
#' @param elementId 
#'
#' @return
#' @export
#'
#' @examples
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
                             aggregatorName = "Sum",
                             rendererName = "Stacked Bar Chart",
                             cols = "year",
                             rows = c("tech", "comm", "sup", "dem"),
                             vals = "value")
    
  } else {
    return(dft)
  }
}
