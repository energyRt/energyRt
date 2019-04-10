# reduce_mapping

# Add reduce mapping
.Object@parameters[['mTechInpTot']] <- createParameter('mTechInpTot', c('comm', 'region', 'year', 'slice'), 'map') 
.Object@parameters[['mTechOutTot']] <- createParameter('mTechOutTot', c('comm', 'region', 'year', 'slice'), 'map') 
.Object@parameters[['mSupOutTot']] <- createParameter('mSupOutTot', c('comm', 'region', 'slice'), 'map') 
.Object@parameters[['mDemInp']] <- createParameter('mDemInp', c('comm', 'slice'), 'map') 
.Object@parameters[['mEmsFuelTot']] <- createParameter('mEmsFuelTot', c('comm', 'region', 'year', 'slice'), 'map') 
.Object@parameters[['mTechEmsFuel']] <- createParameter('mTechEmsFuel', c('tech', 'comm', 'region', 'year', 'slice'), 'map') 
.Object@parameters[['mDummyImport']] <- createParameter('mDummyImport', c('comm', 'region', 'year', 'slice'), 'map') 
.Object@parameters[['mDummyExport']] <- createParameter('mDummyExport', c('comm', 'region', 'year', 'slice'), 'map') 
.Object@parameters[['mDummyCost']] <- createParameter('mDummyCost', c('comm', 'region', 'year'), 'map') 
.Object@parameters[['mTradeIr']] <- createParameter('mTradeIr', c('trade', 'region', 'region', 'year', 'slice'), 'map') 
prec <- .Object


# .reduce_mapping <- function(prec) {
  generate_noinf <- function(nam) {
    gg <- getParameterData(prec@parameters[[nam]])
    if (prec@parameters[[nam]]@defVal == Inf) {
      gg <- gg[gg$value != Inf, colnames(gg) != 'value', drop = FALSE]
    } else {
      gg <- gg[gg$value != Inf, colnames(gg) != 'value', drop = FALSE]
      # add all sets multipliers
      sets0 <- prec@parameters[[nam]]@dimSetNames
      sets <- NULL
      for (i in sets0) {
        if (is.null(sets)) {
          sets <- getParameterData(prec@parameters[[i]])
        } else {
          if (any(i == c('comm', 'slice')) && any(colnames(sets) %in% c('comm', 'slice'))) {
            sets <- merge(sets, merge(getParameterData(prec@parameters$mCommSlice), getParameterData(prec@parameters[[i]])))
          } else {
            sets <- merge(sets, getParameterData(prec@parameters[[i]]))
          }
        }
      }
      gg <- rbind(gg, sets)
      gg <- gg[!duplicated(gg),, drop = FALSE]
    }
    gg
  }

  tmp <- list()
  for (i in names(prec@parameters)) 
    if (prec@parameters[[i]]@type == 'map')
    tmp[[i]] <- getParameterData(prec@parameters[[i]])
  nam <- 'pDummyImportCost'
  # For Inf problem
  for (i in c('pDummyImportCost', 'pDummyExportCost')) 
      tmp[[i]] <- generate_noinf(i)
  
  
  # Non zeros
  #tmp$pAggregateFactor <- getParameterData(prec@parameters$pAggregateFactor)
  #tmp$pAggregateFactor <- tmp$pAggregateFactor[tmp$pAggregateFactor$value != 0, colnames(tmp$pAggregateFactor) != 'value', drop = FALSE]
  #!! Have to add non-zeros functions
  #!! , 'pTradeIrUp' # Have to add Inf & zero options
  
  reduce.sect <- function(x, set) {
    x <- x[, set, drop = FALSE]
    x[!duplicated(x),, drop = FALSE]
  }

# mTechInpTot(comm, region, year, slice)
#   (sum(tech$(mTechSlice(tech, slice) and mTechSpan(tech, region, year) and 
#   (mTechInpComm(tech, comm) or mTechAInp(tech, comm))), 1))
  prec@parameters[['mTechInpTot']] <- addData(prec@parameters[['mTechInpTot']], 
    reduce.sect(merge(merge(tmp$mTechSlice, tmp$mTechSpan, by = 'tech'), rbind(tmp$mTechInpComm, tmp$mTechAInp), 
                                                    by = 'tech'), c('comm', 'region', 'year', 'slice')))
# mTechOutTot(comm, region, year, slice)               Total technology output
#    (mTechSlice(tech, slice) and mTechSpan(tech, region, year) 
#    and (mTechOutComm(tech, comm) or mTechAOut(tech, comm))), 1))  
    prec@parameters[['mTechOutTot']] <- addData(prec@parameters[['mTechOutTot']], 
       reduce.sect(merge(merge(tmp$mTechSlice, tmp$mTechSpan, by = 'tech'), rbind(tmp$mTechOutComm, tmp$mTechAOut), 
          by = 'tech'), c('comm', 'region', 'year', 'slice')))
# mSupOutTot(comm, region, slice)
#   (sum(sup$(mSupSlice(sup, slice) and mSupComm(sup, comm) and mSupSpan(sup, region)), 1))
    prec@parameters[['mSupOutTot']] <- addData(prec@parameters[['mSupOutTot']], 
      reduce.sect(merge(merge(tmp$mSupSlice, tmp$mSupComm, by = 'sup'), tmp$mSupSpan, by = 'sup'), 
          c('comm', 'region', 'slice')))
# mDemInp(comm, slice)
#   (sum(dem$mDemComm(dem, comm), 1) and mCommSlice(comm, slice))    
    prec@parameters[['mDemInp']] <- addData(prec@parameters[['mDemInp']], 
        reduce.sect(merge(tmp$mCommSlice, tmp$mDemComm, by = 'comm'), c('comm', 'slice')))
# mTechEmsFuel(tech, comm, region, year, slice)
#  (sum(tech$(mTechSlice(tech, slice) and mTechSpan(tech, region, year) and mTechEmitedComm(tech, comm)), 1)) 
    prec@parameters[['mTechEmsFuel']] <- addData(prec@parameters[['mTechEmsFuel']], 
       merge(tmp$mTechSpan, merge(tmp$mTechSlice, tmp$mTechEmitedComm, by = 'tech'), by = 'tech')[, c('tech', 'comm', 'region', 'year', 'slice')])
# mEmsFuelTot(comm, region, year, slice)
#  (sum(tech$(mTechSlice(tech, slice) and mTechSpan(tech, region, year) and mTechEmitedComm(tech, comm)), 1)) 
    prec@parameters[['mEmsFuelTot']] <- addData(prec@parameters[['mEmsFuelTot']], 
     reduce.sect(getParameterData(prec@parameters[['mTechEmsFuel']]), 
                 c('comm', 'region', 'year', 'slice')))
# mDummyImport(comm, region, year, slice)
#    (mCommSlice(comm, slice) and pDummyImportCost(comm, region, year, slice) <> Inf)    
    prec@parameters[['mDummyImport']] <- addData(prec@parameters[['mDummyImport']], tmp$pDummyImportCost)
# mDummyExport(comm, region, year, slice)
#    (mCommSlice(comm, slice) and pDummyExportCost(comm, region, year, slice) <> Inf)    
    prec@parameters[['mDummyExport']] <- addData(prec@parameters[['mDummyExport']], tmp$pDummyExportCost)
    
# mDummyCost(comm, region, year)
#    (pDummyImportCost(comm, region, year, slice) <> Inf or pDummyExportCost(comm, region, year, slice) <> Inf)   
    prec@parameters[['mDummyCost']] <- addData(prec@parameters[['mDummyCost']], 
        reduce.sect(rbind(tmp$pDummyImportCost, tmp$pDummyExportCost), c('comm', 'region', 'year')))
# mTradeIr(trade, region, region, year, slice)         Total physical trade flows between regions
# mTradeSlice(trade, slice) and pTradeIrUp(trade, src, dst, year, slice) <> 0 and
#    mTradeSrc(trade, src) and mTradeDst(trade, dst) and not(mSameRegion(src, dst))
    
    
    
#}