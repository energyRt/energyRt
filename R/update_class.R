.remove_all_par_from_param <- function(scen, lst) {
  cls <- class(lst[[1]])
  slc <- c(technology = 'tech', supply = 'sup', storage = 'stg', demand = 'dem')[cls]
  all_par <- grep('^(p|m)Cns', names(scen@modInp@parameters), value = TRUE, invert = TRUE)
  tec_name <- sapply(lst, function(x) x@name)
  # Remove previous data
  for (i in all_par) {
    if (any(scen@modInp@parameters[[i]]@dimSetNames == slc)) {
      if (scen@modInp@parameters[[i]]@nValues != -1) {
        scen@modInp@parameters[[i]]@data <- scen@modInp@parameters[[i]]@data[seq_len(scen@modInp@parameters[[i]]@nValues),, drop = FALSE]
      }
      scen@modInp@parameters[[i]]@data <- scen@modInp@parameters[[i]]@data[!(scen@modInp@parameters[[i]]@data[, slc] %in% tec_name),, drop = FALSE]
      if (scen@modInp@parameters[[i]]@nValues != -1) {
        scen@modInp@parameters[[i]]@nValues <- nrow(scen@modInp@parameters[[i]]@data)
      }
    }
  }
  # Add change technology
  for(i in seq_along(tec_name)) {
    scen@modInp <- add_name(scen@modInp, lst[[i]], scen@misc$approxim)
  }
  scen@modInp@set <- lapply(scen@modInp@parameters[sapply(scen@modInp@parameters, function(x) x@type == 'set')], function(x) getParameterData(x)[, 1])
  for(i in seq_along(tec_name)) {
    scen@modInp <- energyRt:::.add0(scen@modInp, lst[[i]], approxim = scen@misc$approxim)
  }
  scen
}
.update_scenario_class <- function(scen, ...) {
  p1 = proc.time()[3];
  cat('Update model ')
  arg <- list(...)
  if (length(arg) == 1 && class(arg[[1]]) == 'list') {
    arg <- arg[[1]]
  }
  cls <- sapply(arg, class)
  arg <- lapply(unique(cls), function(x) arg[x == cls])  
  names(arg) <- unique(cls)
  for (i in c('technology', 'supply', 'storage', 'demand'))
    if (!is.null(arg[[i]])) {
      scen <- .remove_all_par_from_param(scen, arg[[i]])
  }
  # Clean
  # scen@modInp <- .add0(scen@modInp, scen@model@sysInfo, approxim = scen@misc$approxim) 
  # Reduce mapping
  reduce_map <- c('mTechInpTot',  'mTechOutTot',  'mSupOutTot',  'mDemInp',  'mTechEmsFuel',  'mEmsFuelTot',  
                   'mDummyImport',  'mDummyExport',  'mDummyCost',  'mTradeIr',  'mTradeIrUp',  'mTradeIrAInp2',  'mTradeIrAInpTot',  
                   'mTradeIrAOut2',  'mTradeIrAOutTot',  'mImportRow',  'mImportRowUp',  'mImportRowAccumulatedUp',  'mExportRow',  'mExportRowUp',  
                   'mExportRowAccumulatedUp',  'mExport',  'mImport',  'mStorageInpTot',  'mStorageOutTot',  'mTaxCost',  'mSubsCost',  'mAggOut',  'mSupAva',  
                   'mSupAvaUp',  'mSupReserveUp',  'mTechAfUp',  'mTechAfcUp',  'mTechOlifeInf',  'mStorageOlifeInf',  'mOut2Lo',  'mInp2Lo')
  for (i in reduce_map) {
    scen@modInp@parameters[[i]]@data <- scen@modInp@parameters[[i]]@data[0,, drop = FALSE]
    if (scen@modInp@parameters[[i]]@nValues != -1) 
      scen@modInp@parameters[[i]]@nValues <- 0
  }
  scen@modInp <- energyRt:::.reduce_mapping(scen@modInp)
  # Clean parameters, need when nValues != -1, and mean that add NA row for speed
  for(i in names(scen@modInp@parameters)) {
    if (scen@modInp@parameters[[i]]@nValues != -1) {
      scen@modInp@parameters[[i]]@data <- scen@modInp@parameters[[i]]@data[
        seq(length.out = scen@modInp@parameters[[i]]@nValues),, drop = FALSE]
    }
  }
  cat(round(proc.time()[3] - p1, 2), 's\n', sep = '')
  scen
}

# scen = BAU; arg = list(Build_250_2030)