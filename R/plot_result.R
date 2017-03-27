plot.result <- function(obj, type, commodity, region = NULL, year = NULL,
  slice = NULL, technology = NULL, supply = NULL, export = NULL, import = NULL,
  main = NULL, xlab = '', ylab = '', lwd = 2, ylim = NULL) {
  if (is.null(year)) year <- obj@set$year
  if (is.null(commodity)) commodity <- obj@set$comm
  if (is.null(region)) region <- obj@set$region
  if (is.null(slice)) slice <- obj@set$slice
  if (is.null(technology)) technology <- obj@set$tech
  if (is.null(supply)) supply <- obj@set$sup
  if (is.null(export)) export <- obj@set$expp
  if (is.null(import)) import <- obj@set$imp

  als_type <- c(
  'Summary output',
  'Summary input',
  'Summary emission',
  'Summary aggregate commodity',
  'Summary supply commodity',
  'Technology output',
  'Technology input',
  'Demand',
  'Dummy import',
  'Balance',
  'Export',
  'Import'
  )
  names(als_type) <- c('output',  'input',  'emission',  'aggregate',
  'supply',  'tech_output',  'tech_input',  'demand',  'dummy', 'balance', 
  'export', 'import')
  if (type == 'output') {
    gg <- apply(obj@data$vOutTot[commodity, region, year, slice, drop = FALSE], 3, sum)
  } else if (type == 'input') {
    gg <- apply(obj@data$vInpTot[commodity, region, year, slice, drop = FALSE], 3, sum)
  } else if (type == 'emission') {
    gg <- apply(obj@data$vEmsTot[commodity, region, year, slice, drop = FALSE], 3, sum)
  } else if (type == 'aggregate') {
    gg <- apply(obj@data$vAggOut[commodity, region, year, slice, drop = FALSE], 3, sum)
  } else if (type == 'supply') {
    gg <- apply(obj@data$vSupOut[supply, commodity, region, year, slice, drop = FALSE], 4, sum)
  } else if (type == 'tech_output') {
    gg <- apply(obj@data$vTechOut[technology, commodity, region, year, slice, drop = FALSE], 4, sum)
  } else if (type == 'tech_input') {
    gg <- apply(obj@data$vTechInp[technology, commodity, region, year, slice, drop = FALSE], 4, sum)
  } else if (type == 'demand') {
    gg <- apply(obj@data$vDemInp[commodity, region, year, slice, drop = FALSE], 3, sum)
  } else if (type == 'dummy_output') {
    gg <- apply(obj@data$vDummyImport[commodity, region, year, slice, drop = FALSE], 3, sum)
  } else if (type == 'dummy_input') {
    gg <- apply(obj@data$vDummyExport[commodity, region, year, slice, drop = FALSE], 3, sum)
  } else if (type == 'balance') {
    gg <- apply(obj@data$vBalance[commodity, region, year, slice, drop = FALSE], 3, sum)
  } else if (type == 'export') {      
    gg <- apply(obj@data$vExport[commodity, region, year, slice, drop = FALSE], 3, sum)
  } else if (type == 'import') {
    gg <- apply(obj@data$vImport[commodity, region, year, slice, drop = FALSE], 3, sum)
  } else stop('Unknown plot type, possible type: "', paste(names(als_type), collapse = '", "'), '"')
  if (is.null(main)) {
    main <- paste(als_type[type], commodity)
  }
  plot(year, gg, main = main, xlab = xlab, ylab = ylab, type = 'l', lwd = lwd, ylim = ylim)
  gg
}

plot.scenario <- function(obj, ...) plot(obj@result, ...)
