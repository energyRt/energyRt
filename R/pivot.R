pivot <- function(scen = NULL, var = NULL, ...) {
  #df <- arrayhelpers::array2df(scen@result@data[[var]], label.x = var)
  df <- as.data.frame.table(scen@result@data[[var]], responseName = var)
  df <- df[df[, var] != 0, ]
  rpivotTable::rpivotTable(df,
                           aggregatorName = "Sum",
                           rendererName = "Stacked Bar Chart",
                           cols = "year",
                           rows = c("tech", "comm", "sup"),
                           vals = var, ...)
}
