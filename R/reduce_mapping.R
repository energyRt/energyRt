# reduce_mapping

#  prec0 = prec
# .Object <- prec0;
#if (FALSE) {
# Add reduce mapping

#prec <- .Object

.reduce_mapping <- function(prec) {
  assign('prec', prec, globalenv())
  cat('begin reduce mapping\n'); flush.console()
  # stop()
  reduce.duplicate <- function(x) x[!duplicated(x),, drop = FALSE]

  # Remove not milestone data
  #for (i in c('mTechSpan')) {
  #  getParameterData(prec@parameters[[i]])
  #}
  
  #! need add tech reductions
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
      if (i == 'slice' && any(colnames(sets) == 'comm')) {
        tmp <- merge(tmp_map$mCommSlice, tmp)
      } 
      if (i == 'comm' && any(colnames(sets) == 'sup')) {
        tmp <- merge(tmp_map$mSupComm, tmp)
      }      
      if (i == 'year') {
        tmp <- merge(tmp_map$year, tmp)
      }
      if (i == 'year' && any(colnames(sets) == 'tech')) {
        tmp <- merge(tmp_map$mTechSpan, tmp)
      }
      if (i == 'region' && any(colnames(sets) == 'tech') && all(sets0 != 'year')) {
        tmp <- merge(reduce.duplicate(tmp_map$mTechSpan[, c('tech', 'region')]), tmp)
      }
      
      if (i == 'comm' && any(colnames(sets) == 'tech')) {
        tmp <- merge(rbind(tmp_map$mTechInpComm, tmp_map$mTechOutComm), tmp)
      }
      if (i == 'slice' && any(colnames(sets) == 'tech')) {
        tmp <- merge(tmp_map$mTechSlice, tmp)
      }
      if (i == 'src') {
        aa <- tmp_map$mTradeSrc
        colnames(aa)[2] <- 'src'
        tmp <- merge(aa, tmp)
      }
      if (i == 'dst') {
        aa <- tmp_map$mTradeDst
        colnames(aa)[2] <- 'dst'
        tmp <- merge(aa, tmp)
      }
      if (i == 'comm' && any(colnames(sets) == 'trade')) {
        tmp <- merge(tmp_map$mTradeComm, tmp)
      }
      if (is.null(sets)) {
        sets <- tmp
      } else {
          sets <- merge(sets, tmp)
      }
    }
    if (nrow(sets) > 0) {
      sets$value <- dff
      gg <- rbind(gg, sets)
      gg <- gg[!duplicated(gg[, colnames(gg) != 'value']),, drop = FALSE]
    }
    if (!invert) 
      return(gg[gg$value == val, colnames(gg) != 'value', drop = FALSE])
    return(gg[gg$value != val, colnames(gg) != 'value', drop = FALSE])
  }
  
  generate_noinf <- function(nam) {
    generate_haveval(nam, Inf, TRUE)
  }

  tmp_map <- list()
  for (i in names(prec@parameters)) 
    if (prec@parameters[[i]]@type %in% c('map', 'set'))
      tmp_map[[i]] <- getParameterData(prec@parameters[[i]])
  tmp_map$year <- tmp_map$mMidMilestone
  # For Inf problem
  tmp_noinf <- list()
  for (i in c('pDummyImportCost', 'pDummyExportCost', 'pImportRowRes', 'pExportRowRes')) 
    tmp_noinf[[i]] <- generate_noinf(i)
  for (i in c('pTradeIr', 'pExportRow', 'pImportRow', 'pSupAva', 'pSupReserve', 'pTechAf', 'pTechAfc')) 
    tmp_noinf[[i]] <- generate_haveval(i, Inf, TRUE, 'up')
  tmp_nozero <- list()
 # p1 <- proc.time()[3]
  for (i in c('pTradeIr', 'pExportRow', 'pImportRow', 'pSupAva', 'pTechAf', 'pTechAfc', 'pSupReserve')) {
   # cat('begin: ', i, ', time: ', round(proc.time()[3] - p1, 2), '\n', sep = '')
    tmp_nozero[[i]] <- generate_haveval(i, 0, TRUE, 'up')
    #cat('end: ', i, ', time: ', round(proc.time()[3] - p1, 2), '\n', sep = ''); flush.console()
  }
  
  for (i in c('pDummyImportCost', 'pDummyExportCost', 'pTradeIrCsrc2Ainp', 'pTradeIrCdst2Ainp', 
              'pTradeIrCsrc2Aout', 'pTradeIrCdst2Aout', 'pTaxCost', 'pSubsCost', 'pAggregateFactor')) 
    tmp_nozero[[i]] <- generate_haveval(i, 0, TRUE, 'l')
  
  for (i in c('pDummyImportCost', 'pDummyExportCost')) {
    tmp_nozero[[i]] <- merge(tmp_nozero[[i]], tmp_map$mCommSlice)[, c('comm', 'region', 'year', 'slice')]
    tmp_noinf[[i]] <- merge(tmp_noinf[[i]], tmp_map$mCommSlice)[, c('comm', 'region', 'year', 'slice')]
  }
  # Non zeros
  #tmp_map$pAggregateFactor <- getParameterData(prec@parameters$pAggregateFactor)
  #tmp_map$pAggregateFactor <- tmp_map$pAggregateFactor[tmp_map$pAggregateFactor$value != 0, colnames(tmp_map$pAggregateFactor) != 'value', drop = FALSE]
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
    reduce.sect(merge(merge(tmp_map$mTechSlice, tmp_map$mTechSpan, by = 'tech'), rbind(tmp_map$mTechInpComm, tmp_map$mTechAInp), 
                                                    by = 'tech'), c('comm', 'region', 'year', 'slice')))
# mTechOutTot(comm, region, year, slice)               Total technology output
#    (mTechSlice(tech, slice) and mTechSpan(tech, region, year) 
#    and (mTechOutComm(tech, comm) or mTechAOut(tech, comm))), 1))  
    prec@parameters[['mTechOutTot']] <- addData(prec@parameters[['mTechOutTot']], 
       reduce.sect(merge(merge(tmp_map$mTechSlice, tmp_map$mTechSpan, by = 'tech'), rbind(tmp_map$mTechOutComm, tmp_map$mTechAOut), 
          by = 'tech'), c('comm', 'region', 'year', 'slice')))
# mSupOutTot(comm, region, slice)
#   (sum(sup$(mSupSlice(sup, slice) and mSupComm(sup, comm) and mSupSpan(sup, region)), 1))
    prec@parameters[['mSupOutTot']] <- addData(prec@parameters[['mSupOutTot']], 
      reduce.sect(merge(merge(tmp_map$mSupSlice, tmp_map$mSupComm, by = 'sup'), tmp_map$mSupSpan, by = 'sup'), 
          c('comm', 'region', 'slice')))
# mDemInp(comm, slice)
#   (sum(dem$mDemComm(dem, comm), 1) and mCommSlice(comm, slice))    
    prec@parameters[['mDemInp']] <- addData(prec@parameters[['mDemInp']], 
        reduce.sect(merge(tmp_map$mCommSlice, tmp_map$mDemComm, by = 'comm'), c('comm', 'slice')))
# mTechEmsFuel(tech, comm, region, year, slice)
#  (sum(tech$(mTechSlice(tech, slice) and mTechSpan(tech, region, year) and mTechEmitedComm(tech, comm)), 1)) 
    prec@parameters[['mTechEmsFuel']] <- addData(prec@parameters[['mTechEmsFuel']], 
       merge(tmp_map$mTechSpan, merge(tmp_map$mTechSlice, tmp_map$mTechEmitedComm, by = 'tech'), by = 'tech')[, c('tech', 'comm', 'region', 'year', 'slice')])
# mEmsFuelTot(comm, region, year, slice)$(sum(tech$(mTechSpan(tech, region, year) and mTechSlice(tech, slice) and mTechEmitedComm(tech, comm)), 1))  
prec@parameters[['mEmsFuelTot']] <- addData(prec@parameters[['mEmsFuelTot']], 
                                            reduce.sect(getParameterData(prec@parameters[['mTechEmsFuel']]), c('comm', 'region', 'year', 'slice')))
# mDummyImport(comm, region, year, slice)
#    (mCommSlice(comm, slice) and pDummyImportCost(comm, region, year, slice) <> Inf)    
    prec@parameters[['mDummyImport']] <- addData(prec@parameters[['mDummyImport']], tmp_noinf$pDummyImportCost)
# mDummyExport(comm, region, year, slice)
#    (mCommSlice(comm, slice) and pDummyExportCost(comm, region, year, slice) <> Inf)    
    prec@parameters[['mDummyExport']] <- addData(prec@parameters[['mDummyExport']], tmp_noinf$pDummyExportCost)
    
# mDummyCost(comm, region, year)
#    (pDummyImportCost(comm, region, year, slice) <> Inf or pDummyExportCost(comm, region, year, slice) <> Inf)   
    prec@parameters[['mDummyCost']] <- addData(prec@parameters[['mDummyCost']], 
        reduce.sect(rbind(getParameterData(prec@parameters[['mDummyImport']]), 
                          getParameterData(prec@parameters[['mDummyExport']])), c('comm', 'region', 'year')))
# mTradeIr(trade, region, region, year, slice)         Total physical trade flows between regions
# mTradeSlice(trade, slice) and pTradeIrUp(trade, src, dst, year, slice) <> 0 and
#    mTradeSrc(trade, src) and mTradeDst(trade, dst) and not(mSameRegion(src, dst))
    a1 <- tmp_map$mTradeSrc; colnames(a1)[2] <- 'src'
    a2 <- tmp_map$mTradeDst; colnames(a2)[2] <- 'dst'
    aa <- merge(a1, a2)
    aa <- aa[aa$src != aa$dst,, drop = FALSE]
    aa <- merge(aa, merge(tmp_nozero$pTradeIr, tmp_map$mTradeSlice))[, c("trade", "src", "dst", "year", "slice")] 
    colnames(aa)[2:3] <- 'region'
    prec@parameters[['mTradeIr']] <- addData(prec@parameters[['mTradeIr']], aa[, ])
# mTradeIrUp(trade, region, region, year, slice)         Total physical trade flows between regions is constrain
# mTradeSlice(trade, slice) and pTradeIrUp(trade, src, dst, year, slice) != Inf and
#    mTradeSrc(trade, src) and mTradeDst(trade, dst) and not(mSameRegion(src, dst))
    a1 <- tmp_map$mTradeSrc; colnames(a1)[2] <- 'src'
    a2 <- tmp_map$mTradeDst; colnames(a2)[2] <- 'dst'
    bb <- merge(a1, a2)
    bb <- bb[bb$src != bb$dst,, drop = FALSE]
    bb <- merge(bb, merge(merge(tmp_noinf$pTradeIr, tmp_nozero$pTradeIr), 
                          tmp_map$mTradeSlice))[, c("trade", "src", "dst", "year", "slice")]
    colnames(bb)[2:3] <- 'region'
    prec@parameters[['mTradeIrUp']] <- addData(prec@parameters[['mTradeIrUp']], bb[, ])
    # mTradeIrAInp2(trade, comm, region, year, slice)
    a0 <- tmp_map$mTradeIrAInp; colnames(a0)[2] <- 'acomm' 
    a1 <- merge(a0, rbind(tmp_nozero$pTradeIrCsrc2Ainp, tmp_nozero$pTradeIrCdst2Ainp))
    colnames(a1)[2:4] <- c('comm', 'region', 'region.1')
    prec@parameters[['mTradeIrAInp2']] <- addData(prec@parameters[['mTradeIrAInp2']], 
          merge(a1, getParameterData(prec@parameters$mTradeIr))[, c('trade', 'comm', 'region', 'year', 'slice')])
    # mTradeIrAInpTot
    prec@parameters[['mTradeIrAInpTot']] <- addData(prec@parameters[['mTradeIrAInpTot']], 
        reduce.sect(getParameterData(prec@parameters$mTradeIrAInp2), c('comm', 'region', 'year', 'slice')))
    
    # mTradeIrAOut2(trade, comm, region, year, slice)
    a0 <- tmp_map$mTradeIrAOut; colnames(a0)[2] <- 'acomm' 
    a1 <- merge(a0, rbind(tmp_nozero$pTradeIrCsrc2Aout, tmp_nozero$pTradeIrCdst2Aout))
    colnames(a1)[2:4] <- c('comm', 'region', 'region.1')
    prec@parameters[['mTradeIrAOut2']] <- addData(prec@parameters[['mTradeIrAOut2']], 
        merge(a1, getParameterData(prec@parameters$mTradeIr))[, c('trade', 'comm', 'region', 'year', 'slice')])
    # mTradeIrAOutTot
    prec@parameters[['mTradeIrAOutTot']] <- addData(prec@parameters[['mTradeIrAOutTot']], 
      reduce.sect(getParameterData(prec@parameters$mTradeIrAOut2), c('comm', 'region', 'year', 'slice')))
    
    # (mImpSlice(imp, slice) and mImpComm(imp, comm) and pImportRowUp(imp, region, year, slice) <> 0)
    aa <- merge(tmp_map$mImpComm, merge(tmp_map$mImpSlice, tmp_nozero$pImportRow))[, c("imp", "comm", "region", "year", "slice")]
    prec@parameters[['mImportRow']] <- addData(prec@parameters[['mImportRow']], aa)
    # (mImpSlice(imp, slice) and mImpComm(imp, comm) and pImportRowUp(imp, region, year, slice) <> 0 and pImportRowUp(imp, region, year, slice) <> Inf) 
    prec@parameters[['mImportRowUp']] <- addData(prec@parameters[['mImportRowUp']], 
                                                 reduce.sect(merge(tmp_noinf$pImportRow, aa), c("imp", "comm", "region", "year", "slice")))
    prec@parameters[['mImportRowAccumulatedUp']] <- addData(prec@parameters[['mImportRowAccumulatedUp']], tmp_noinf$pImportRowRes)
    # (mImpSlice(imp, slice) and mImpComm(imp, comm) and pImportRowUp(imp, region, year, slice) <> 0)
    aa <- reduce.sect(merge(tmp_map$mExpComm, merge(tmp_map$mExpSlice, tmp_nozero$pExportRow)), c("expp", "comm", "region", "year", "slice"))
    
    prec@parameters[['mExportRow']] <- addData(prec@parameters[['mExportRow']], aa)
    prec@parameters[['mExportRowUp']] <- addData(prec@parameters[['mExportRowUp']], reduce.sect(merge(tmp_noinf$pExportRow, aa), c("expp", "comm", "region", "year", "slice")))
    prec@parameters[['mExportRowAccumulatedUp']] <- addData(prec@parameters[['mExportRowAccumulatedUp']], tmp_noinf$pExportRowRes)
    # sum(expp$mExportRow(expp, comm, region, year, slice), 1) + sum((trade, dst)$(mTradeIr(trade, region, dst, year, slice) and mTradeComm(trade, comm)), 1) <> 0
    prec@parameters[['mExport']] <- addData(prec@parameters[['mExport']], reduce.sect(
                                            rbind(merge(tmp_map$mTradeComm, getParameterData(prec@parameters[['mTradeIr']]))[, c('comm', 'region', 'year', 'slice')],
                                                  getParameterData(prec@parameters[['mExportRow']])[, c('comm', 'region', 'year', 'slice')]), 
                                                  c('comm', 'region', 'year', 'slice')))
    # sum(expp$mImportRow(imp, comm, region, year, slice), 1) + sum((trade, src)$(mTradeIr(trade, src, region, year, slice) and mTradeComm(trade, comm)), 1) <> 0
    zz <- merge(tmp_map$mTradeComm, getParameterData(prec@parameters[['mTradeIr']]))[, c('comm', 'region.1', 'year', 'slice')]
    colnames(zz)[2] <- 'region'
    prec@parameters[['mImport']] <- addData(prec@parameters[['mImport']], reduce.sect(
      rbind(zz, getParameterData(prec@parameters[['mImportRow']])[, c('comm', 'region', 'year', 'slice')]), 
      c('comm', 'region', 'year', 'slice')))
 
    
# mStorageInpTot(comm, region, year, slice)
#     (sum(stg$(mStorageSlice(stg, slice) and mStorageComm(stg, comm) and mStorageSpan(stg, region, year)), 1) and (mStorageComm(stg, comm) or mStorageAInp(stg, comm)))
    prec@parameters[['mStorageInpTot']] <- addData(prec@parameters[['mStorageInpTot']], 
          reduce.sect(merge(tmp_map$mStorageSpan, merge(merge(tmp_map$mStorageSlice, tmp_map$mStorageComm, by = 'stg'),
              rbind(tmp_map$mStorageComm, tmp_map$mStorageAInp))), c('comm', 'region', 'year', 'slice')))
# mStorageOutTot(comm, region, year, slice)
#     (sum(stg$(mStorageSlice(stg, slice) and mStorageComm(stg, comm) and mStorageSpan(stg, region, year)), 1) and (mStorageComm(stg, comm) or mStorageAOut(stg, comm)))
    prec@parameters[['mStorageOutTot']] <- addData(prec@parameters[['mStorageOutTot']], 
        reduce.sect(merge(tmp_map$mStorageSpan, merge(merge(tmp_map$mStorageSlice, tmp_map$mStorageComm, by = 'stg'),
            rbind(tmp_map$mStorageComm, tmp_map$mStorageAOut))), c('comm', 'region', 'year', 'slice')))
# mTaxCost(comm, region, year)  sum(slice$pTaxCost(comm, region, year, slice), 1)
    prec@parameters[['mTaxCost']] <- addData(prec@parameters[['mTaxCost']], reduce.sect(tmp_nozero$pTaxCost, c('comm', 'region', 'year')))
# mSubsCost(comm, region, year)  sum(slice$pSubsCost(comm, region, year, slice), 1)
    prec@parameters[['mSubsCost']] <- addData(prec@parameters[['mSubsCost']], reduce.sect(tmp_nozero$pSubsCost, c('comm', 'region', 'year')))
#    (sum(commp$pAggregateFactor(comm, commp), 1))
    prec@parameters[['mAggOut']] <- addData(prec@parameters[['mAggOut']], reduce.duplicate(merge(merge(merge(reduce.sect(
      tmp_nozero$pAggregateFactor, 'comm'), tmp_map$region), tmp_map$year), tmp_map$slice)))
    
    prec@parameters[['mSupAvaUp']] <- addData(prec@parameters[['mSupAvaUp']],
                                              reduce.duplicate(merge(tmp_nozero$pSupAva, tmp_noinf$pSupAva)))
    prec@parameters[['mSupReserveUp']] <- addData(prec@parameters[['mSupReserveUp']], reduce.duplicate(
      merge(tmp_nozero$pSupReserve, tmp_noinf$pSupReserve)))
    
    prec@parameters[['mTechAfUp']] <- addData(prec@parameters[['mTechAfUp']], reduce.duplicate(merge(tmp_nozero$pTechAf, tmp_noinf$pTechAf)))
    prec@parameters[['mTechAfcUp']] <- addData(prec@parameters[['mTechAfcUp']], reduce.duplicate(merge(tmp_nozero$pTechAfc, tmp_noinf$pTechAfc)))
    prec@parameters[['mTechOlifeInf']] <- addData(prec@parameters[['mTechOlifeInf']], generate_haveval('pTechOlife', Inf))
    prec@parameters[['mStorageOlifeInf']] <- addData(prec@parameters[['mStorageOlifeInf']], generate_haveval('pStorageOlife', Inf))
    
    
    #sum(slicep$(mAllSliceParentChild(slice, slicep) and mCommSlice(comm, slicep)), 1) and
    #(mSupOutTot(comm, region, slice) or mEmsFuelTot(comm, region, year, slice) or mAggOut(comm, region, year, slice) or
    #  mTechOutTot(comm, region, year, slice) or mStorageOutTot(comm, region, year, slice) or mImport(comm, region, year, slice) or
    #  mTradeIrAOutTot(comm, region, year, slice))
    a1 <- tmp_map$mCommSlice; colnames(a1)[2] <- 'slicep'
    a2 <- tmp_map$mAllSliceParentChild
    for2Lo <- merge(a1, a2, by = 'slicep'); for2Lo$slicep <- NULL
    for2Lo <- reduce.duplicate(for2Lo)
    for (i in c('mSupOutTot', 'mEmsFuelTot', 'mAggOut', 'mTechOutTot', 'mStorageOutTot', 'mImport', 'mTradeIrAOutTot', 'mTechInpTot', 
                'mStorageInpTot', 'mExport', 'mTradeIrAInpTot')) 
        tmp_map[[i]] <- getParameterData(prec@parameters[[i]])
    cll <- c('comm', 'region', 'year', 'slice')
    
    prec@parameters[['mOut2Lo']] <- addData(prec@parameters[['mOut2Lo']], merge(reduce.duplicate(rbind(merge(tmp_map$mSupOutTot, tmp_map$year)[, cll], 
      tmp_map$mEmsFuelTot[, cll], tmp_map$mAggOut[, cll], tmp_map$mTechOutTot[, cll], tmp_map$mStorageOutTot[, cll], 
      tmp_map$mImport[, cll], tmp_map$mTradeIrAOutTot[, cll])), for2Lo, by =  c('comm', 'slice'))[, cll])
    
    # sum(slicep$(mAllSliceParentChild(slice, slicep) and mCommSlice(comm, slicep)), 1) <> 0
    #   and (mTechInpTot(comm, region, year, slice) or  mStorageInpTot(comm, region, year, slice) or
    #   or mExport(comm, region, year, slice) or mTradeIrAInpTot(comm, region, year, slice))
    
    prec@parameters[['mInp2Lo']] <- addData(prec@parameters[['mInp2Lo']], merge(reduce.duplicate(rbind(tmp_map$mTechInpTot[, cll], 
        tmp_map$mStorageInpTot[, cll], tmp_map$mExport[, cll], tmp_map$mTradeIrAInpTot[, cll])), for2Lo, by =  c('comm', 'slice'))[, cll])
    
    
    cat('end reduce mapping\n'); flush.console()
    prec
}

