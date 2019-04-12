# reduce_mapping

# .Object <- prec
if (FALSE) {
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
.Object@parameters[['mTradeIrAInp2']] <- createParameter('mTradeIrAInp2', c('trade', 'comm', 'region', 'year', 'slice'), 'map') 
.Object@parameters[['mTradeIrAOut2']] <- createParameter('mTradeIrAOut2', c('trade', 'comm', 'region', 'year', 'slice'), 'map') 

.Object@parameters[['mImportRow']] <- createParameter('mImportRow', c('imp', 'comm', 'region', 'year', 'slice'), 'map') 
.Object@parameters[['mExportRow']] <- createParameter('mExportRow', c('expp', 'comm', 'region', 'year', 'slice'), 'map') 
.Object@parameters[['mImportRowUp']] <- createParameter('mImportRowUp', c('imp', 'comm', 'region', 'year', 'slice'), 'map') 
.Object@parameters[['mExportRowUp']] <- createParameter('mExportRowUp', c('expp', 'comm', 'region', 'year', 'slice'), 'map') 
.Object@parameters[['mImportAccumulatedRowUp']] <- createParameter('mImportAccumulatedRowUp', c('imp', 'comm'), 'map') 
.Object@parameters[['mExportRowAccumulatedUp']] <- createParameter('mExportRowAccumulatedUp', c('expp', 'comm'), 'map') 

.Object@parameters[['mExport']] <- createParameter('mExport', c('comm', 'region', 'year', 'slice'), 'map') 
.Object@parameters[['mImport']] <- createParameter('mImport', c('comm', 'region', 'year', 'slice'), 'map') 

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
    if (nrow(sets) > 0) {
      sets$value <- dff
      gg <- rbind(gg, sets)
      gg <- gg[!duplicated(gg),, drop = FALSE]
    }
    if (!invert) 
      return(gg[gg$value == val, colnames(gg) != 'value', drop = FALSE])
    return(gg[gg$value != val, colnames(gg) != 'value', drop = FALSE])
  }
  generate_noinf <- function(nam) {
    generate_haveval(nam, Inf, TRUE)
  }

  tmp <- list()
  for (i in names(prec@parameters)) 
    if (prec@parameters[[i]]@type %in% c('map', 'set'))
      tmp[[i]] <- getParameterData(prec@parameters[[i]])
  # For Inf problem
  tmp_noinf <- list()
  for (i in c('pDummyImportCost', 'pDummyExportCost', 'pImportRowRes', 'pExportRowRes')) 
    tmp_noinf[[i]] <- generate_noinf(i)
  for (i in c('pTradeIr', 'pExportRow', 'pImportRow')) 
    tmp_noinf[[i]] <- generate_haveval(i, Inf, TRUE, 'up')
  tmp_nozero <- list()
  for (i in c('pTradeIr', 'pExportRow', 'pImportRow')) 
    tmp_nozero[[i]] <- generate_haveval(i, 0, TRUE, 'up')
  for (i in c('pDummyImportCost', 'pDummyExportCost', 'pTradeIrCsrc2Ainp', 'pTradeIrCdst2Ainp', 'pTradeIrCsrc2Aout', 'pTradeIrCdst2Aout')) 
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
    # mTradeIrAInp2(trade, comm, region, year, slice)
    a0 <- tmp$mTradeIrAInp; colnames(a0)[2] <- 'acomm' 
    a1 <- merge(a0, rbind(tmp_nozero$pTradeIrCsrc2Ainp, tmp_nozero$pTradeIrCdst2Ainp))
    colnames(a1)[3:4] <- c('region', 'region.1')
    prec@parameters[['mTradeIrAInp2']] <- addData(prec@parameters[['mTradeIrAInp2']], 
                                                  merge(a1, getParameterData(prec@parameters$mTradeIr))[, c('trade', 'acomm', 'region', 'year', 'slice')])
    # mTradeIrAOut2(trade, comm, region, year, slice)
    a0 <- tmp$mTradeIrAOut; colnames(a0)[2] <- 'acomm' 
    a1 <- merge(a0, rbind(tmp_nozero$pTradeIrCsrc2Aout, tmp_nozero$pTradeIrCdst2Aout))
    colnames(a1)[3:4] <- c('region', 'region.1')
    prec@parameters[['mTradeIrAOut2']] <- addData(prec@parameters[['mTradeIrAOut2']], 
                                                  merge(a1, getParameterData(prec@parameters$mTradeIr))[, c('trade', 'acomm', 'region', 'year', 'slice')])

    # (mImpSlice(imp, slice) and mImpComm(imp, comm) and pImportRowUp(imp, region, year, slice) <> 0)
    aa <- merge(tmp$mImpComm, merge(tmp$mImpSlice, tmp_nozero$pImportRow))[, c("imp", "comm", "region", "year", "slice")]
    prec@parameters[['mImportRow']] <- addData(prec@parameters[['mImportRow']], aa)
    # (mImpSlice(imp, slice) and mImpComm(imp, comm) and pImportRowUp(imp, region, year, slice) <> 0 and pImportRowUp(imp, region, year, slice) <> Inf) 
    prec@parameters[['mImportRowUp']] <- addData(prec@parameters[['mImportRowUp']], merge(tmp_noinf$pImportRow, aa))
    prec@parameters[['mImportAccumulatedRowUp']] <- addData(prec@parameters[['mImportAccumulatedRowUp']], tmp_noinf$pImportRowRes)
    # (mImpSlice(imp, slice) and mImpComm(imp, comm) and pImportRowUp(imp, region, year, slice) <> 0)
    aa <- merge(tmp$mExpComm, merge(tmp$mExpSlice, tmp_nozero$pExportRow))[, c("expp", "comm", "region", "year", "slice")]
    prec@parameters[['mExportRow']] <- addData(prec@parameters[['mExportRow']], aa)
    prec@parameters[['mExportRowUp']] <- addData(prec@parameters[['mExportRowUp']], merge(tmp_noinf$pExportRow, aa))
    prec@parameters[['mExportRowAccumulatedUp']] <- addData(prec@parameters[['mExportRowAccumulatedUp']], tmp_noinf$pExportRowRes)

    
    
    # sum(expp$mExportRow(expp, comm, region, year, slice), 1) + sum((trade, dst)$(mTradeIr(trade, region, dst, year, slice) and mTradeComm(trade, comm)), 1) <> 0
    
    mExport(comm, region, year, slice)
    # sum(imp$mImportRow(imp, comm, region, year, slice), 1) + sum((trade, src)$(mTradeIr(trade, src, region, year, slice) and mTradeComm(trade, comm)), 1) <> 0
    mImport(comm, region, year, slice)

    
        # * (sum(trade$(mTradeSlice(trade, slice) and mTradeComm(trade, comm) and mTradeSrc(trade, src)), 1) + sum(expp$(mExpSlice(expp, slice) and mExpComm(expp, comm)), 1))
    prec@parameters[['mExport']] <- addData(prec@parameters[['mExport']], 
      rbind(merge(tmp$mTradeComm, getParameterData(prec@parameters[['mTradeIr']]))[, c('comm', 'region', 'year', 'slice')],
        reduce.sect(getParameterData(prec@parameters[['mExportRow']]), c('comm', 'region', 'year', 'slice'))))
    
    

    
    
}