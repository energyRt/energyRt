################################################################################
# Remove previous commodity
################################################################################
setMethod('removePreviousCommodity',
    signature(obj = 'CodeProduce', name = 'character'),
      function(obj, name) {
        for(i in c('comm', 'mUpComm', 'mLoComm', 'mFxComm'))
            obj@maptable[[i]] <- removeBySet(obj@maptable[[i]], 'comm', name)
        for(i in c('pEmissionFactor')) # 'ems_from', 
            obj@maptable[[i]] <- removeBySet(obj@maptable[[i]], 'commp', name)
        obj
})
################################################################################
# Get commodity name
################################################################################

sm_isCommodity_CodeProduce_character <- function(obj, name) {
  fl <- FALSE
  for(i in c('comm', 'mUpComm', 'mLoComm', 'mFxComm'))
      fl <- fl || any(obj@maptable[[i]]@data$comm == name, na.rm = TRUE)
  for(i in c('pEmissionFactor')) # 'ems_from', 
      fl <- fl || any(obj@maptable[[i]]@data$commp == name, na.rm = TRUE)
  fl
}

setMethod('isCommodity', signature(obj = 'CodeProduce', name = 'character'), 
  sm_isCommodity_CodeProduce_character)

################################################################################
# Remove previous demand
################################################################################
setMethod('removePreviousDemand',
    signature(obj = 'CodeProduce', name = 'character'),
      function(obj, name) {
        for(i in c('pDemand')) 
            obj@maptable[[i]] <- removeBySet(obj@maptable[[i]], 'comm', name)
        obj
})
################################################################################
# Get commodity demand
################################################################################
setMethod('isDemand', signature(obj = 'CodeProduce', name = 'character'),
      function(obj, name) {
        fl <- FALSE
        for(i in c('pDemand')) 
            fl <- fl || any(obj@maptable[[i]]@data$comm == name, na.rm = TRUE)
        fl
})

################################################################################
# Remove previous supply
################################################################################
setMethod('removePreviousSupply',
    signature(obj = 'CodeProduce', name = 'character'),
      function(obj, name) {
        for(i in c('sup', 'mSupComm', 'pSupCost', 'pSupAva', 'pSupReserve')) 
            obj@maptable[[i]] <- removeBySet(obj@maptable[[i]], 'sup', name)
        obj
})
################################################################################
# Get commodity supply
################################################################################
setMethod('isSupply', signature(obj = 'CodeProduce', name = 'character'),
      function(obj, name) {
        fl <- FALSE
        for(i in c('sup', 'mSupComm', 'pSupCost', 'pSupAva', 'pSupReserve')) 
            fl <- fl || any(obj@maptable[[i]]@data$sup == name, na.rm = TRUE)
        fl
})


################################################################################
# Remove previous export
################################################################################
setMethod('removePreviousExport',
    signature(obj = 'CodeProduce', name = 'character'),
      function(obj, name) {
        for(i in c('expp', 'mExpComm', 'pRowExportPrice', 'pRowExportRes', 
           'pRowExport')) 
            obj@maptable[[i]] <- removeBySet(obj@maptable[[i]], 'expp', name)
        obj
})
################################################################################
# Get commodity export
################################################################################
setMethod('isExport', signature(obj = 'CodeProduce', name = 'character'),
      function(obj, name) {
        fl <- FALSE
        for(i in c('expp', 'mExpComm', 'pRowExportPrice', 'pRowExportRes', 
           'pRowExport')) 
            fl <- fl || any(obj@maptable[[i]]@data$expp == name, na.rm = TRUE)
        fl
})


################################################################################
# Remove previous import
################################################################################
setMethod('removePreviousImport',
    signature(obj = 'CodeProduce', name = 'character'),
      function(obj, name) {
        for(i in c('imp', 'mImpComm', 'pRowImportPrice', 'pRowImportRes', 
           'pRowImport')) 
            obj@maptable[[i]] <- removeBySet(obj@maptable[[i]], 'imp', name)
        obj
})
################################################################################
# Get commodity import
################################################################################
setMethod('isImport', signature(obj = 'CodeProduce', name = 'character'),
      function(obj, name) {
        fl <- FALSE
        for(i in c('imp', 'mImpComm', 'pRowImportPrice', 'pRowImportRes', 
           'pRowImport')) 
            fl <- fl || any(obj@maptable[[i]]@data$imp == name, na.rm = TRUE)
        fl
})


################################################################################
# Remove previous technology
################################################################################
setMethod('removePreviousTechnology',
    signature(obj = 'CodeProduce', name = 'character'),
      function(obj, name) {
      stop('should be done')
        obj
})
################################################################################
# Get technology
################################################################################
setMethod('isTechnology', signature(obj = 'CodeProduce', name = 'character'),
      function(obj, name) {
  any(obj@maptable$tech@data$tech == name, na.rm = TRUE)
})

################################################################################
# Get constrain
################################################################################
setMethod('isConstrain', signature(obj = 'CodeProduce', name = 'character'),
      function(obj, name) {
  any(names(obj@constrain) == name)
})


################################################################################
# Remove previous sysInfo
################################################################################
setMethod('removePreviousSysInfo',
    signature(obj = 'CodeProduce'),
      function(obj) {
        for(i in c('pDiscount', 'pDumCost')) 
            obj@maptable[[i]] <- clear(obj@maptable[[i]])
        obj
})
