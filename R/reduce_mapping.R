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
.Object@parameters[['mTradeIrUp']] <- createParameter('mTradeIrUp', c('trade', 'region', 'region', 'year', 'slice'), 'map') 
prec <- .Object


# .reduce_mapping <- function(prec) {
  generate_haveval <- function(nam, val, invert = FALSE, type = 'l') {
    gg <- getParameterData(prec@parameters[[nam]])
    if (type == 'lo') {
      gg <- gg[gg$type == 'lo', colnames(gg) != 'type', drop = FALSE]
      dff <- prec@parameters[[nam]]@defVal[1]
    } else if (type == 'up') {
      gg <- gg[gg$type == 'up', colnames(gg) != 'type', drop = FALSE]
      dff <- prec@parameters[[nam]]@defVal[2]
    } else if (type == 'l') {
      dff <- prec@parameters[[nam]]@defVal
    }  
    if (dff != val && !invert) 
      return(gg[gg$value == val, colnames(gg) != 'value', drop = FALSE])
    if (dff == val && invert) 
      return(gg[gg$value != val, colnames(gg) != 'value', drop = FALSE])
    # Generate full sets
    sets0 <- prec@parameters[[nam]]@dimSetNames
    sets <- NULL
    for (i in sets0) {
      j <- i
      if (any(i == c('src', 'dst'))) j <- 'region'
      tmp <- getParameterData(prec@parameters[[j]])
      colnames(tmp) <- i
      if (is.null(sets)) {
        sets <- tmp
      } else {
        if (any(i == c('comm', 'slice')) && any(colnames(sets) %in% c('comm', 'slice'))) {
          sets <- merge(sets, merge(getParameterData(prec@parameters$mCommSlice), tmp))
        } else {
          sets <- merge(sets, tmp)
        }
      }
    }
    sets$value <- dff
    gg <- rbind(gg, sets)
    gg <- gg[!duplicated(gg),, drop = FALSE]
    if (!invert) 
      return(gg[gg$value == val, colnames(gg) != 'value', drop = FALSE])
    return(gg[gg$value != val, colnames(gg) != 'value', drop = FALSE])
  }
  generate_noinf <- function(nam) {
    generate_haveval(nam, Inf, TRUE)
  }

  tmp <- list()
  for (i in names(prec@parameters)) 
    if (prec@parameters[[i]]@type == 'map')
      tmp[[i]] <- getParameterData(prec@parameters[[i]])
  # For Inf problem
  tmp_noinf <- list()
  for (i in c('pDummyImportCost', 'pDummyExportCost')) 
    tmp_noinf[[i]] <- generate_noinf(i)
  for (i in c('pTradeIr')) 
    tmp_noinf[[i]] <- generate_haveval(i, Inf, TRUE, 'up')
  tmp_nozero <- list()
  for (i in c('pTradeIr')) 
    tmp_nozero[[i]] <- generate_haveval(i, 0, TRUE, 'up')
  for (i in c('pDummyImportCost', 'pDummyExportCost')) 
    tmp_nozero[[i]] <- generate_haveval(i, 0, TRUE, 'l')
  
  
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
    prec@parameters[['mDummyImport']] <- addData(prec@parameters[['mDummyImport']], 
                                                 rbind(tmp_noinf$pDummyImportCost, tmp_nozero$pDummyImportCost))
# mDummyExport(comm, region, year, slice)
#    (mCommSlice(comm, slice) and pDummyExportCost(comm, region, year, slice) <> Inf)    
    prec@parameters[['mDummyExport']] <- addData(prec@parameters[['mDummyExport']], 
                                                 rbind(tmp_noinf$pDummyExportCost, tmp_nozero$pDummyExportCost))
    
# mDummyCost(comm, region, year)
#    (pDummyImportCost(comm, region, year, slice) <> Inf or pDummyExportCost(comm, region, year, slice) <> Inf)   
    prec@parameters[['mDummyCost']] <- addData(prec@parameters[['mDummyCost']], 
        reduce.sect(rbind(tmp_noinf$pDummyImportCost, tmp_noinf$pDummyExportCost, 
                          tmp_nozero$pDummyImportCost, tmp_nozero$pDummyExportCost), c('comm', 'region', 'year')))
# mTradeIr(trade, region, region, year, slice)         Total physical trade flows between regions
# mTradeSlice(trade, slice) and pTradeIrUp(trade, src, dst, year, slice) <> 0 and
#    mTradeSrc(trade, src) and mTradeDst(trade, dst) and not(mSameRegion(src, dst))
    a1 <- tmp$mTradeSrc; colnames(a1)[2] <- 'src'
    a2 <- tmp$mTradeDst; colnames(a2)[2] <- 'dst'
    aa <- merge(a1, a2)
    aa <- aa[aa$src != aa$dst,, drop = FALSE]
    aa <- merge(aa, merge(tmp_nozero$pTradeIr, tmp$mTradeSlice))[, c("trade", "src", "dst", "year", "slice")] 
    colnames(aa)[2:3] <- 'region'
    prec@parameters[['mTradeIr']] <- addData(prec@parameters[['mTradeIr']], aa[, ])
# mTradeIrUp(trade, region, region, year, slice)         Total physical trade flows between regions is constrain
# mTradeSlice(trade, slice) and pTradeIrUp(trade, src, dst, year, slice) != Inf and
#    mTradeSrc(trade, src) and mTradeDst(trade, dst) and not(mSameRegion(src, dst))
    a1 <- tmp$mTradeSrc; colnames(a1)[2] <- 'src'
    a2 <- tmp$mTradeDst; colnames(a2)[2] <- 'dst'
    bb <- merge(a1, a2)
    bb <- bb[bb$src != bb$dst,, drop = FALSE]
    bb <- merge(bb, merge(merge(tmp_noinf$pTradeIr, tmp_nozero$pTradeIr), 
                          tmp$mTradeSlice))[, c("trade", "src", "dst", "year", "slice")]
    colnames(bb)[2:3] <- 'region'
    prec@parameters[['mTradeIrUp']] <- addData(prec@parameters[['mTradeIrUp']], bb[, ])
    
    
#}