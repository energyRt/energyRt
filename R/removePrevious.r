################################################################################
# Remove previous commodity
################################################################################
setMethod('removePreviousCommodity',
    signature(obj = 'modInp', name = 'character'),
      function(obj, name) {
        for(i in c('comm', 'mUpComm', 'mLoComm', 'mFxComm'))
            obj@parameters[[i]] <- removeBySet(obj@parameters[[i]], 'comm', name)
        for(i in c('pEmissionFactor')) # 'ems_from', 
            obj@parameters[[i]] <- removeBySet(obj@parameters[[i]], 'commp', name)
        obj
})
################################################################################
# Get commodity name
################################################################################

sm_isCommodity_modInp_character <- function(obj, name) {
  fl <- FALSE
  for(i in c('comm', 'mUpComm', 'mLoComm', 'mFxComm'))
      fl <- fl || any(obj@parameters[[i]]@data$comm == name, na.rm = TRUE)
  for(i in c('pEmissionFactor')) # 'ems_from', 
      fl <- fl || any(obj@parameters[[i]]@data$commp == name, na.rm = TRUE)
  fl
}

setMethod('isCommodity', signature(obj = 'modInp', name = 'character'), 
  sm_isCommodity_modInp_character)

################################################################################
# Remove previous demand
################################################################################
setMethod('removePreviousDemand',
    signature(obj = 'modInp', name = 'character'),
      function(obj, name) {
        for(i in c('pDemand')) 
            obj@parameters[[i]] <- removeBySet(obj@parameters[[i]], 'comm', name)
        obj
})
################################################################################
# Get commodity demand
################################################################################
setMethod('isDemand', signature(obj = 'modInp', name = 'character'),
      function(obj, name) {
        fl <- FALSE
        for(i in c('pDemand')) 
            fl <- fl || any(obj@parameters[[i]]@data$comm == name, na.rm = TRUE)
        fl
})

################################################################################
# Remove previous supply
################################################################################
setMethod('removePreviousSupply',
    signature(obj = 'modInp', name = 'character'),
      function(obj, name) {
        for(i in c('sup', 'mSupComm', 'pSupCost', 'pSupAva', 'pSupReserve')) 
            obj@parameters[[i]] <- removeBySet(obj@parameters[[i]], 'sup', name)
        obj
})
################################################################################
# Get commodity supply
################################################################################
setMethod('isSupply', signature(obj = 'modInp', name = 'character'),
      function(obj, name) {
        fl <- FALSE
        for(i in c('sup', 'mSupComm', 'pSupCost', 'pSupAva', 'pSupReserve')) 
            fl <- fl || any(obj@parameters[[i]]@data$sup == name, na.rm = TRUE)
        fl
})


################################################################################
# Remove previous export
################################################################################
setMethod('removePreviousExport',
    signature(obj = 'modInp', name = 'character'),
      function(obj, name) {
        for(i in c('expp', 'mExpComm', 'pRowExportPrice', 'pRowExportRes', 
           'pRowExport')) 
            obj@parameters[[i]] <- removeBySet(obj@parameters[[i]], 'expp', name)
        obj
})
################################################################################
# Get commodity export
################################################################################
setMethod('isExport', signature(obj = 'modInp', name = 'character'),
      function(obj, name) {
        fl <- FALSE
        for(i in c('expp', 'mExpComm', 'pExportRowPrice', 'pExportRowRes', 
           'pExportRow')) 
            fl <- fl || any(obj@parameters[[i]]@data$expp == name, na.rm = TRUE)
        fl
})


################################################################################
# Remove previous import
################################################################################
setMethod('removePreviousImport',
    signature(obj = 'modInp', name = 'character'),
      function(obj, name) {
        for(i in c('imp', 'mImpComm', 'pImportRowPrice', 'pImportRowRes', 
           'pImportRow')) 
            obj@parameters[[i]] <- removeBySet(obj@parameters[[i]], 'imp', name)
        obj
})
################################################################################
# Remove previous trade
################################################################################
setMethod('removePreviousTrade',
    signature(obj = 'modInp', name = 'character'),
      function(obj, name) {
      stop('should be done')
        obj
})
################################################################################
# Get trade 
################################################################################
setMethod('isTrade', signature(obj = 'modInp', name = 'character'),
      function(obj, name) {
  any(obj@parameters$trade@data$trade == name, na.rm = TRUE)
})
################################################################################
# Get commodity import
################################################################################
setMethod('isImport', signature(obj = 'modInp', name = 'character'),
      function(obj, name) {
        fl <- FALSE
        for(i in c('imp', 'mImpComm', 'pImportRowPrice', 'pImportRowRes', 
           'pImportRow')) 
            fl <- fl || any(obj@parameters[[i]]@data$imp == name, na.rm = TRUE)
        fl
})


################################################################################
# Remove previous technology
################################################################################
setMethod('removePreviousTechnology',
    signature(obj = 'modInp', name = 'character'),
      function(obj, name) {
      stop('should be done')
        obj
})
################################################################################
# Get technology
################################################################################
setMethod('isTechnology', signature(obj = 'modInp', name = 'character'),
      function(obj, name) {
  any(obj@parameters$tech@data$tech == name, na.rm = TRUE)
})

################################################################################
# Get constrain
################################################################################
setMethod('isConstrain', signature(obj = 'modInp', name = 'character'),
      function(obj, name) {
  any(names(obj@parameters$constrain) == name)
})


################################################################################
# Remove previous sysInfo
################################################################################
setMethod('removePreviousSysInfo',
    signature(obj = 'modInp'),
      function(obj) {
        for(i in c('pDiscount', 'pDummyImportCost', 'pDummyExportCost')) 
            obj@parameters[[i]] <- clear(obj@parameters[[i]])
        obj
})
