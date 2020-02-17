.replace_tech_sup_stg_dem <- function(scen, lst) {
  cls <- class(lst[[1]])
  slc <- c(technology = 'tech', supply = 'sup', storage = 'stg', demand = 'dem', export = 'expp', import = 'imp')[cls]
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

.replace_comm <- function(scen, lst) {
	# May only add commodity, not remove
	cls <- class(lst[[1]])
	# Add change technology
	for(i in seq_along(lst)) {
		scen@modInp <- add_name(scen@modInp, lst[[i]], scen@misc$approxim)
	}
	scen@misc$approxim$commodity_slice_map <- .get_map_commodity_slice_map(scen)
	scen@modInp@set <- lapply(scen@modInp@parameters[sapply(scen@modInp@parameters, function(x) x@type == 'set')], function(x) getParameterData(x)[, 1])
	for(i in seq_along(lst)) {
		scen@modInp <- energyRt:::.add0(scen@modInp, lst[[i]], approxim = scen@misc$approxim)
	}
	scen
}


.replace_taxsub <- function(scen, lst) {
  cls <- class(lst[[1]])
  if (cls == 'tax') prm <- 'pTaxCost' else prm <- 'pSubsCost' 
  comm_out <- sapply(lst, function(x) x@comm)
  
  if (scen@modInp@parameters[[prm]]@nValues != -1) {
    scen@modInp@parameters[[prm]]@data <- scen@modInp@parameters[[prm]]@data[seq_len(scen@modInp@parameters[[prm]]@nValues),, drop = FALSE]
  }
  scen@modInp@parameters[[prm]]@data <- scen@modInp@parameters[[prm]]@data[!(scen@modInp@parameters[[prm]]@data[, 'comm'] %in% comm_out),, drop = FALSE]
  if (scen@modInp@parameters[[prm]]@nValues != -1) {
    scen@modInp@parameters[[prm]]@nValues <- nrow(scen@modInp@parameters[[prm]]@data)
  }
  # Add data
  for (i in seq_along(lst))
    scen@modInp <- energyRt:::.add0(scen@modInp, lst[[i]], approxim = scen@misc$approxim)
  scen
}

.replace_inmodel <- function(scen, arg) {
	arg <- arg[sapply(arg, class) != 'sysInfo']
  nms <- sapply(arg, function(x) x@name)
  for(i in seq(along = scen@model@data)) {
    scen@model@data[[i]]@data <- scen@model@data[[i]]@data[sapply(scen@model@data[[i]]@data, function(x) !(x@name %in% nms))]
  }
  for(i in seq(along = arg)) {
    scen@model <- add(scen@model, arg[[i]])
  }
  scen
}


.replace_constraint <- function(scen, lst) {
  scen <- energyRt:::.remove_constraint(scen, sapply(lst, function(x) x@name))
  for(i in seq_along(lst)) {
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
  not_rel <- cls[!(cls %in%c('technology', 'supply', 'storage', 'demand', 'tax', 'sub', 
  	'constraint', 'sysInfo', 'commodity', 'export', 'import'))]
  if (length(not_rel))
    stop(paste0('Not relised class for "', paste0(not_rel, collapse = '", "'), '"'))
  # Replace in model
  scen <- .replace_inmodel(scen, arg)
  
  #Replace in parameters
  arg <- lapply(unique(cls), function(x) arg[x == cls])  
  names(arg) <- unique(cls)
  if (!is.null(arg$commodity)) 
  	scen <- .replace_comm(scen, arg$commodity)
  for (i in c('technology', 'supply', 'storage', 'demand', 'export', 'import'))
    if (!is.null(arg[[i]])) {
      scen <- .replace_tech_sup_stg_dem(scen, arg[[i]])
    }
  for (i in c('tax', 'sub'))
    if (!is.null(arg[[i]])) {
      scen <- .replace_taxsub(scen, arg[[i]])
    }
  if (!is.null(arg$constraint)) 
  	scen <- .replace_constraint(scen, arg$constraint)
  if (!is.null(arg$sysInfo))
  	scen@model@sysInfo <- arg$sysInfo[[1]]
  # Clean
  # Reduce mapping
  sys_info_par <- c('mSliceParentChild', 
                    'mSliceParentChildE', 'mSliceNext', 'pDiscount', 'pSliceShare', 'pDummyImportCost', 'pDummyExportCost', 
                    'mStartMilestone', 'mEndMilestone', 'mMilestoneLast', 'mMilestoneFirst', 'mMilestoneNext', 'mMilestoneHasNext', 
                    'mSameSlice', 'mSameRegion', 'ordYear', 'cardYear', 'pPeriodLen', 'pDiscountFactor', 'mDiscountZero')
  reduce_map <- c('mTechInpTot',  'mTechOutTot',  'mSupOutTot',  'mDemInp',  'mTechEmsFuel',  'mEmsFuelTot',  
                   'mDummyImport',  'mDummyExport',  'mDummyCost',  'mTradeIr',  'mTradeIrUp',  'mvTradeIrAInp',  'mTradeIrAInpTot',  
                   'mvTradeIrAOut',  'mTradeIrAOutTot',  'mImportRow',  'mImportRowUp',  'mImportRowAccumulatedUp',  'mExportRow',  'mExportRowUp',  
                   'mExportRowAccumulatedUp',  'mExport',  'mImport',  'mStorageInpTot',  'mStorageOutTot',  'mTaxCost',  'mSubsCost',  'mAggOut',  'mSupAva',  
                   'mSupAvaUp',  'mSupReserveUp',  'mTechAfUp',  'mTechAfcUp',  'mTechOlifeInf',  'mStorageOlifeInf',  'mOut2Lo',  'mInp2Lo')
  for (i in c(sys_info_par, reduce_map)) {
    scen@modInp@parameters[[i]]@data <- scen@modInp@parameters[[i]]@data[0,, drop = FALSE]
    if (scen@modInp@parameters[[i]]@nValues != -1) 
      scen@modInp@parameters[[i]]@nValues <- 0
  }
  scen@modInp <- .add0(scen@modInp, scen@model@sysInfo, approxim = scen@misc$approxim) 
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