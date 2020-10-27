.find_commodity <- function(modInp, name) {
  fl <- FALSE
  for(i in c('comm', 'mUpComm', 'mLoComm', 'mFxComm'))
    fl <- fl || any(modInp@parameters[[i]]@data$comm == name, na.rm = TRUE)
  for(i in c('pEmissionFactor')) # 'ems_from', 
    fl <- fl || any(modInp@parameters[[i]]@data$commp == name, na.rm = TRUE)
  fl
}

.drop_commodity <- function(modInp, name) {
  for(i in c('comm', 'mUpComm', 'mLoComm', 'mFxComm'))
    modInp@parameters[[i]] <- .drop_set_value(modInp@parameters[[i]], 'comm', name)
  for(i in c('pEmissionFactor')) # 'ems_from', 
    modInp@parameters[[i]] <- .drop_set_value(modInp@parameters[[i]], 'commp', name)
  modInp
}

.find_demand <- function(obj, name) {
  fl <- FALSE
  for(i in c('pDemand')) 
    fl <- fl || any(obj@parameters[[i]]@data$comm == name, na.rm = TRUE)
  fl
}

.drop_demand <- function(modInp, name) {
  for(i in c('pDemand')) 
    modInp@parameters[[i]] <- .drop_set_value(modInp@parameters[[i]], 'comm', name)
  modInp
}

.find_weather <- function(modInp, name) {
  fl <- FALSE
  for(i in c('pWeather')) 
    fl <- fl || any(modInp@parameters[[i]]@data$comm == name, na.rm = TRUE)
  fl
}

.drop_weather <- function(modInp, name) {
  stop('The method is not available for class "weather", re-interpolation is required ', name)
  modInp
}

.find_supply <- function(modInp, name) {
  fl <- FALSE
  for(i in c('sup', 'mSupComm', 'pSupCost', 'pSupAva', 'pSupReserve')) 
      fl <- fl || any(modInp@parameters[[i]]@data$sup == name, na.rm = TRUE)
  fl
}

.drop_supply <- function(modInp, name) {
  for(i in c('sup', 'mSupComm', 'pSupCost', 'pSupAva', 'pSupReserve')) 
    modInp@parameters[[i]] <- .drop_set_value(modInp@parameters[[i]], 'sup', name)
  modInp
}

.find_export <- function(modInp, name) {
  fl <- FALSE
  for(i in c('expp', 'mExpComm', 'pExportRowPrice', 'pExportRowRes', 'pExportRow')) 
      fl <- fl || any(modInp@parameters[[i]]@data$expp == name, na.rm = TRUE)
  fl
}

.drop_export <- function(modInp, name) {
  for(i in c('expp', 'mExpComm', 'pRowExportPrice', 'pRowExportRes', 'pRowExport')) 
    modInp@parameters[[i]] <- .drop_set_value(modInp@parameters[[i]], 'expp', name)
  modInp
}

.find_import <- function(modInp, name) {
  fl <- FALSE
  for(i in c('imp', 'mImpComm', 'pImportRowPrice', 'pImportRowRes', 
             'pImportRow')) 
    fl <- fl || any(modInp@parameters[[i]]@data$imp == name, na.rm = TRUE)
  fl
}

.drop_import <- function(modInp, name) {
  for(i in c('imp', 'mImpComm', 'pImportRowPrice', 'pImportRowRes', 
     'pImportRow')) 
    modInp@parameters[[i]] <- .drop_set_value(modInp@parameters[[i]], 'imp', name)
  modInp
}

.find_trade <- function(modInp, name) {
  any(modInp@parameters$trade@data$trade == name, na.rm = TRUE)
}

.drop_trade <- function(modInp, name) {
  stop('The method is not available for class "trade", re-interpolation is required ', name)
  modInp
}

.find_technology <- function(modInp, name) {
  any(modInp@parameters$tech@data$tech == name, na.rm = TRUE)
}

.drop_technology <- function(modInp, name) {
  stop('The method is not available for class "technology", re-interpolation is required ', name)
  modInp
}

.find_constraint <- function(modInp, name) {
  any(names(modInp@parameters$constraint) == name)
}

.drop_sysinfo_param <- function(modInp) {
  for(i in c('pDiscount', 'pDummyImportCost', 'pDummyExportCost')) 
    modInp@parameters[[i]] <- .reset(modInp@parameters[[i]])
  modInp
}

.get_stg_prm_lst <- function() {
  # vector with parameter-names, relevant to "storage"
  c('mStorageSlice', 'ndefpStorageOlife', 'mStorageComm',
    'mStorageNew', 'mStorageSpan', 'ndefpStorageCapUp', 
    'ndefpStorageAvaUp', 'pStorageInpLoss', 'pStorageOutLoss', 
    'pStorageStoreLoss', 'pStorageStock', 'pStorageOlife', 
    'pStorageCapUp', 'pStorageCapLo', 'pStorageCostStore', 
    'pStorageCostInp', 'pStorageCostOut', 'pStorageFixom', 
    'pStorageInvcost', 'pStorageAvaLo', 'pStorageAvaUp')
}

.find_storage <- function(modInp, name) {
  fl <- FALSE
  for(i in .get_stg_prm_lst()) 
    fl <- fl || any(modInp@parameters[[i]]@data$stg == name, na.rm = TRUE)
  fl
}

.drop_storage <- function(obj, name) {
  for(i in .get_stg_prm_lst()) 
    obj@parameters[[i]] <- .drop_set_value(obj@parameters[[i]], 'stg', name)
  obj
}

